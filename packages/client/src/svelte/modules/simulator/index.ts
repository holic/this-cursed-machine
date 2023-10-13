/*
 *  Simulates the changing state of the game
 *
 */
import { EntityType, MachineType, PortType } from "../state/enums"
import { get, writable, derived } from "svelte/store"
import { capAtZero } from "../../modules/utils/misc"
import { portBelongsToBox, connectionBelongsToBox } from "../state/convenience"
import {
  entities,
  playerBox,
  playerEntityId,
  playerCore,
  ports,
  connections,
  machines,
  playerGoals,
} from "../state"
import { blockNumber } from "../network"
import type { SimulatedEntities } from "./types"

// --- CONSTANTS --------------------------------------------------------------
export const AVAILABLE_MACHINES = Object.values(MachineType).splice(
  4, // exclude some
  Object.keys(MachineType).length / 2 - 4
)

// --- STORES -----------------------------------------------------------------

/**
 * Block on which the network was last resolved locally.
 * Used to check against the on-chain lastResolved value.
 */
export const localResolved = writable(0)

/**
 * Current block number - lastResolved
 */
export const blocksSinceLastResolution = derived(
  [blockNumber, playerBox],
  ([$blockNumber, $playerBox]) => {
    return $blockNumber - Number($playerBox.lastResolved)
  }
)

/**
 * Output of the the network resolver.
 */
export const patches = writable({} as SimulatedEntities)

/**
 * Potential machines
 */
export const potential = writable({} as SimulatedEntities)

/**
 * On-chain state with the local patches applied each block.
 */
export const simulated = derived(
  [entities, patches, potential, blocksSinceLastResolution],
  ([$entities, $patches, $potential, $blocksSinceLastResolution]) => {
    // Add a numerical ID to each entry for the terminal
    let i = 0

    let simulated: SimulatedEntities = Object.fromEntries([
      // Entities
      ...Object.entries($entities).map(([key, ent]) => {
        i++
        return [key, { ...ent, numericalID: i }]
      }),
      // Potential
      ...Object.entries($potential).map(([key, ent]) => {
        i++
        return [key, { ...ent, numericalID: i }]
      }),
    ])

    for (const [key, patch] of Object.entries($patches)) {
      // @todo: scaling the products by block since resolution is causing wrong values
      // for (let k = 0; k < simulated[key].intermediaryProducts.length; k++) {
      //     simulated[key].intermediaryProducts[k].amount = patch.intermediaryProducts[k].amount * $blocksSinceLastResolution
      // }
      if (patch.inputs && simulated[key]) {
        simulated[key].inputs = patch.inputs
      }
      if (patch.outputs && simulated[key]) {
        simulated[key].outputs = patch.outputs
      }
    }

    return simulated
  }
)

/** Convenience methods for easy access */

/** Core */
export const simulatedPlayerCore = derived(
  [simulated, playerEntityId],
  ([$simulated, $playerEntityId]) => $simulated[$playerEntityId]
)

/** Boxes */
export const simulatedBoxes = derived(simulated, $simulated => {
  return Object.fromEntries(
    Object.entries($simulated).filter(
      ([_, entry]) => entry.entityType === EntityType.BOX
    )
  )
})

/** Machines */
export const simulatedMachines = derived(
  [simulated, playerCore],
  ([$simulated, $playerCore]) => {
    return Object.fromEntries(
      Object.entries($simulated).filter(([_, entry]) => {
        // osn
        return (
          entry.entityType === EntityType.MACHINE &&
          entry.carriedBy === $playerCore.carriedBy
        )
      })
    )
  }
)

/** Connections */
export const simulatedConnections = derived(
  [simulated, playerCore],
  ([$simulated, $playerCore]) => {
    return Object.fromEntries(
      Object.entries($simulated)
        .filter(([_, entry]) => entry.entityType === EntityType.CONNECTION)
        .filter(([_, entry]) =>
          connectionBelongsToBox(entry, $playerCore.carriedBy)
        )
    )
  }
)

/** Materials */
export const simulatedMaterials = derived(simulated, $simulated => {
  return Object.fromEntries(
    Object.entries($simulated).filter(
      ([_, entry]) => entry.entityType === EntityType.MATERIAL
    )
  )
})

/** Ports */
export const simulatedPorts = derived(
  [simulated, playerCore],
  ([$simulated, $playerCore]) => {
    return Object.fromEntries(
      Object.entries($simulated)
        .filter(([_, entry]) => entry.entityType === EntityType.PORT)
        .filter(([_, entry]) => portBelongsToBox(entry, $playerCore.carriedBy))
    )
  }
)

// --- READABLE ------------------------------------------
export const readableConnections = derived(
  [connections, ports, machines, playerCore],
  ([$connections, $ports, $machines, $playerCore]) => {
    return Object.entries($connections)
      .filter(([_, entry]) =>
        connectionBelongsToBox(entry, $playerCore.carriedBy)
      )
      .map(([id, connection]) => {
        const sP = connection?.sourcePort
        const tP = connection?.targetPort

        if (sP && tP) {
          const ssP = $ports[sP]
          const ttP = $ports[tP]

          if (ssP && ttP) {
            const sourceMachine =
              MachineType[$machines[ssP?.carriedBy]?.machineType]
            const targetMachine =
              MachineType[$machines[ttP?.carriedBy]?.machineType]
            if (sourceMachine && targetMachine) {
              return {
                id,
                connection,
                read: `From ${sourceMachine} To ${targetMachine}`,
              }
            }
          }
        }

        return false
      })
      .filter(ent => ent)
  }
)

export const readableMachines = derived(
  simulatedMachines,
  $simulatedMachines => {
    return Object.entries($simulatedMachines).map(([id, machine]) => ({
      id,
      machine,
      read: `${MachineType[machine.machineType]} (${machine.numericalID})`,
    }))
  }
)

/**
 * Calculates the aggregated amount of each material type carried by the player,
 * considering patches on outlets.
 *
 * @function boxOutput
 * @exports
 * @param {Object} entities - A store containing all in-game entities.
 * @param {Object} playerCore - Store with information about the player's core properties.
 * @param {Number} blocksSinceLastResolution - Count of blockchain blocks since the last resolution.
 * @returns {Object} - An object where each key is a material type and the value is the aggregated amount
 *                     of that material type carried by the player, including patches.
 * @todo The way patches are added to outputs is hacky and needs a more robust solution.
 * @todo There's a need to handle a potential missing outlet.
 * @todo Consider handling scenarios where there are multiple outputs from patches.
 */
export const boxOutput = derived(
  [entities, playerCore, blocksSinceLastResolution],
  ([$entities, $playerCore, $blocksSinceLastResolution]) => {
    // Filter entities to retrieve only those which are of type MATERIAL and are in the same box as the player
    const singles = Object.entries($entities).filter(([_, entry]) => {
      return (
        entry.entityType === EntityType.MATERIAL &&
        entry.carriedBy === $playerCore.carriedBy
      )
    })

    // Initialize the result object.
    let result = {}

    // !!!
    // VERY hacky way to add patches to outputs
    // @todo: fix this

    // Get outlet entity
    const outlet = Object.entries($entities).find(([_, entry]) => {
      return (
        entry.entityType === EntityType.MACHINE &&
        entry.carriedBy === $playerCore.carriedBy &&
        entry.machineType === MachineType.OUTLET
      )
    })

    // Get patches on outlet
    // @todo: handle missing outlet
    const patchesOnOutlet = get(patches)[outlet[0]]

    // Loop through the filtered materials to aggregate their amounts by material type.
    // Materials are consolidated onchain, so there will only ever be one entry per material type.
    singles.forEach(([_, material]) => {
      // Get patch value
      // @todo: possibly handle multiple outputs
      let patchValue =
        patchesOnOutlet &&
          patchesOnOutlet.outputs &&
          patchesOnOutlet.outputs[0] &&
          patchesOnOutlet.outputs[0].materialType === material.materialType
          ? patchesOnOutlet.outputs[0].amount
          : 0
      result[material.materialType] =
        material.amount + patchValue * $blocksSinceLastResolution
    })

    // Handle patches that are not yet resolved
    if (
      patchesOnOutlet &&
      patchesOnOutlet.outputs &&
      patchesOnOutlet.outputs[0] &&
      patchesOnOutlet.outputs[0].materialType &&
      !result[patchesOnOutlet.outputs[0].materialType]
    ) {
      result[patchesOnOutlet.outputs[0].materialType] =
        patchesOnOutlet.outputs[0].amount * $blocksSinceLastResolution
    }

    return result
  }
)

// --- MISC ----------------------------------------------

export const playerEnergyMod = writable(-1)

export const simulatedPlayerEnergy = derived(
  [simulatedPlayerCore, playerEnergyMod, blocksSinceLastResolution],
  ([
    $simulatedPlayerCore,
    $playerEnergyMod,
    $blocksSinceLastResolution,
  ]) => {
    return capAtZero(
      ($simulatedPlayerCore?.energy || 0) + $playerEnergyMod * $blocksSinceLastResolution
    )
  }
)

// Return the number of the last solved level
export const goalsSatisfied = derived(
  [playerGoals, boxOutput, simulatedPlayerEnergy],
  ([$playerGoals, $boxOutput, $simulatedPlayerEnergy]) => {
    const achieved = $playerGoals.map(goal => {
      if (goal?.materialType === 0) {
        return $simulatedPlayerEnergy >= goal?.amount
      }

      const pooledMaterial = $boxOutput[goal.materialType]

      return pooledMaterial && pooledMaterial >= goal?.amount
    })

    return achieved.every(v => v === true)
  }
)


