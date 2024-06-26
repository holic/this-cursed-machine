import { get } from "svelte/store"
import { EMPTY_CONNECTION } from "@modules/utils/constants"
import { SelectOption } from "@components/Main/Terminal/types"
import { COMMAND, DIRECTION } from "@components/Main/Terminal/enums"
import { MACHINE_TYPE } from "@modules/state/base/enums"
import { MaterialIdNone } from "@modules/state/base/constants"
import {
  simulatedMachines,
  simulatedConnections,
  simulatedTanks,
  capacityForBugs,
  machineCapacity,
} from "@modules/state/simulated/stores"
import {
  player,
  tanks as tanksStore,
  offers as offersStore,
  playerTokenBalance,
  materialMetadata,
} from "@modules/state/base/stores"
import {
  FIXED_MACHINE_TYPES,
  MACHINES_BY_LEVEL,
} from "@components/Main/Terminal/"
import { machinePositionSort } from "@components/Main/Terminal/functions/helpers"

import {
  machineTypeToLabel,
  machineIsAvailable,
} from "@modules/state/simulated"
import { displayAmount } from "@modules/utils"

/**
 * Generates select options based on the provided command type and port type.
 * @param {COMMAND} commandType - The type of command for which the select options are generated.
 * @returns {SelectOption[]} An array of select options appropriate for the given command and port type.
 */
export function createSelectOptions(
  commandType: COMMAND,
  direction: DIRECTION = DIRECTION.OUTGOING
): SelectOption[] {
  switch (commandType) {
    case COMMAND.BUILD_MACHINE:
      return createSelectOptionsBuild()
    case COMMAND.REMOVE_MACHINE:
      return createSelectOptionsDestroy()
    case COMMAND.CONNECT:
      return createSelectOptionsConnect(direction)
    case COMMAND.DISCONNECT:
      return createSelectOptionsDisconnect()
    case COMMAND.PLUG_TANK:
      return createSelectOptionsAttachTank()
    case COMMAND.UNPLUG_TANK:
      return createSelectOptionsDetachTank()
    case COMMAND.EMPTY_TANK:
      return createSelectOptionsEmptyTank()
    case COMMAND.FILL_TANK:
      return createSelectOptionsRefillTank()
    case COMMAND.SHIP_TANK:
      return createSelectOptionsShip()
    case COMMAND.WIPE_POD:
      return createSelectOptionsWipe()
    default:
      return [] as SelectOption[]
  }
}

function createSelectOptionsWipe(): SelectOption[] {
  return [{ label: "CONFIRM", value: "true", available: true }]
}

/**
 * Generates select options for building machine types.
 * This function returns select options for all machine types except player, inlet, and outlet.
 * @returns {SelectOption[]} An array of select options representing various machine types.
 */
function createSelectOptionsBuild(): SelectOption[] {
  let selectOptions: SelectOption[] = []
  let availableMachines: MACHINE_TYPE[] =
    MACHINES_BY_LEVEL[get(player)?.tutorialLevel ?? 3]

  for (let i = 0; i < availableMachines.length; i++) {
    selectOptions.push({
      label: MACHINE_TYPE[availableMachines[i]],
      value: availableMachines[i],
      available: get(machineCapacity) > 0,
    })
  }

  return selectOptions
}

/**
 * Generates select options for destroying machines
 * This function returns select options for all machines, excluding the player, inlet, and outlet types.
 * @returns {SelectOption[]} An array of select options representing various machines to destroy, using their machine type as a label and their ID as the value.
 */
function createSelectOptionsDestroy(): SelectOption[] {
  let selectOptions: SelectOption[] = []

  // All machines except player, inlet, outlet
  Object.entries(get(simulatedMachines))
    .sort(machinePositionSort)
    .forEach(([address, machine]) => {
      if (
        !FIXED_MACHINE_TYPES.includes(machine.machineType || MACHINE_TYPE.NONE)
      ) {
        selectOptions.push({
          label: `${machineTypeToLabel(machine.machineType)} #${machine.buildIndex}`,
          value: address,
          available: true,
        })
      }
    })

  return selectOptions
}

/**
 * Creates an array of select options based on machines with available ports of a specified type.
 * @returns {SelectOption[]} An array of select options containing machine types as labels and machine IDs as values.
 */
function createSelectOptionsConnect(direction: DIRECTION): SelectOption[] {
  let selectOptions: SelectOption[] = []

  const machines = get(simulatedMachines)

  selectOptions = Object.entries(machines)
    .sort(machinePositionSort)
    .map(([address, machine]) => ({
      label:
        machineTypeToLabel(machine.machineType) +
        (machine.hasOwnProperty("buildIndex") ? " #" + machine.buildIndex : ""),
      value: address,
      available: machineIsAvailable(direction, machine),
    }))

  return selectOptions
}

/**
 * Generates select options for disconnecting existing connections.
 * This function returns select options for all available connections.
 * @returns {SelectOption[]} An array of select options representing various connections to disconnect, using a generic "Connection" label and the connection ID as the value.
 */
function createSelectOptionsDisconnect(): SelectOption[] {
  let selectOptions: SelectOption[] = []

  const machines = get(simulatedMachines)
  const connections = get(simulatedConnections)

  selectOptions = connections.map(connection => {
    const sourceMachine = machines[connection.sourceMachine]
    const targetMachine = machines[connection.targetMachine]

    const sourceMachineBuildIndex = sourceMachine.hasOwnProperty("buildIndex")
      ? "#" + sourceMachine.buildIndex
      : ""
    const targetMachineBuildIndex = targetMachine.hasOwnProperty("buildIndex")
      ? "#" + targetMachine.buildIndex
      : ""
    const connectionProduct =
      connection?.products?.length > 0
        ? `(${get(materialMetadata)[connection.products[0].materialId].name})`
        : ""

    const label = `${machineTypeToLabel(sourceMachine.machineType)}${sourceMachineBuildIndex} to ${machineTypeToLabel(targetMachine.machineType)}${targetMachineBuildIndex} ${connectionProduct}`

    return {
      label,
      value: connection.id,
      available: true,
    }
  })

  return selectOptions
}

function createSelectOptionsAttachTank(): SelectOption[] {
  let selectOptions: SelectOption[] = []

  const tanks = get(tanksStore)

  // Only tanks that are not attached can be attached
  selectOptions = Object.entries(tanks).map(([address, tank]) => ({
    label: `Tank #${tank.buildIndex}`,
    value: address,
    available: tank.tankConnection === EMPTY_CONNECTION,
  }))

  return selectOptions
}

function createSelectOptionsDetachTank(): SelectOption[] {
  let selectOptions: SelectOption[] = []

  const tanks = get(tanksStore)

  // Only tanks that are attached can be detached
  selectOptions = Object.entries(tanks).map(([address, tank]) => ({
    label: `Tank #${tank.buildIndex}`,
    value: address,
    available: tank.tankConnection !== EMPTY_CONNECTION,
  }))

  return selectOptions
}

function createSelectOptionsEmptyTank(): SelectOption[] {
  let selectOptions: SelectOption[] = []

  const tanks = get(tanksStore)

  // Only tanks that are not attached be emptied
  selectOptions = Object.entries(tanks).map(([address, tank]) => ({
    label: `Tank #${tank.buildIndex}`,
    value: address,
    available:
      tank.tankConnection === EMPTY_CONNECTION && tank.amount !== BigInt(0),
  }))

  return selectOptions
}

function createSelectOptionsRefillTank(): SelectOption[] {
  let selectOptions: SelectOption[] = []

  const offers = get(offersStore)
  const balance = get(playerTokenBalance)

  selectOptions = Object.entries(offers).map(([address, offer]) => ({
    label: `${displayAmount(offer.offer.amount)} ${get(materialMetadata)[offer.offer.materialId].name}`,
    value: address,
    available:
      balance >= displayAmount(offer.offer.cost) &&
      get(capacityForBugs) >= displayAmount(offer.offer.cost),
  }))

  return selectOptions
}

function createSelectOptionsShip(): SelectOption[] {
  let selectOptions: SelectOption[] = []

  // Only detached tanks can be shipped
  const availableTanks = Object.entries(get(simulatedTanks))

  selectOptions = availableTanks.map(([address, tank]) => {
    let materialDescription = "(empty)"
    if (tank.materialId !== MaterialIdNone) {
      materialDescription = `(${displayAmount(tank.amount)} ${get(materialMetadata)[tank.materialId].name})`
    }

    return {
      label: `Tank #${tank.buildIndex} ${materialDescription}`,
      value: address,
      available: tank.materialId !== MaterialIdNone,
    }
  })

  return selectOptions
}
