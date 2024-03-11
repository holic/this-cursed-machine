import { get } from "svelte/store"
import { EMPTY_CONNECTION } from "../../utils"
import { MACHINE_TYPE, MATERIAL_TYPE } from "../base/enums"
import { CONNECTION_STATE } from "./enums"
import type { Connection } from "./types"
import { DIRECTION } from "../../../components/Main/Terminal/types"
import { simulatedMachines, simulatedConnections } from "./stores"

export const availableMachines = (direction: DIRECTION) => {
  const machines = Object.entries(get(simulatedMachines))

  return machines.filter(([_, machine]) => {
    return (
      machine[
        direction === DIRECTION.OUTGOING
          ? "outgoingConnections"
          : "incomingConnections"
      ].filter(connection => connection === EMPTY_CONNECTION).length > 0
    )
  })
}

export const availablePorts = (machine: Machine, direction: DIRECTION) => {
  let ports =
    machine[
    direction === DIRECTION.OUTGOING
      ? "outgoingConnections"
      : "incomingConnections"
    ]
  ports = ports.map((address, i) => ({
    portIndex: i,
    machine,
    address,
  }))
  ports = ports.filter(connection => connection.address === EMPTY_CONNECTION)
  ports = ports.flat()
  return ports
}

const dfs = (
  currentMachineUID: string,
  visited: Set<string>,
  machinesMap: Map<string, Machine>,
  connections: Connection[]
): Set<string> => {
  if (visited.has(currentMachineUID)) return new Set()
  visited.add(currentMachineUID)

  const currentMachine = machinesMap.get(currentMachineUID)
  const flowingConnections = new Set<string>()

  if (currentMachine!.machineType === MACHINE_TYPE.OUTLET) {
    return flowingConnections
  }

  for (const connection of [
    ...currentMachine!.incomingConnections,
    ...currentMachine!.outgoingConnections,
  ]) {
    if (connection !== EMPTY_CONNECTION) {
      const nextMachineUID = connection
      const subFlowingConnections = dfs(
        nextMachineUID,
        visited,
        machinesMap,
        connections
      )
      if (
        subFlowingConnections.size > 0 ||
        machinesMap.get(nextMachineUID)!.machineType === MACHINE_TYPE.OUTLET
      ) {
        flowingConnections.add(currentMachineUID + "->" + nextMachineUID)
        for (const conn of subFlowingConnections) {
          flowingConnections.add(conn)
        }
      }
    }
  }

  return flowingConnections
}

const dfsFlowingEntities = (
  currentMachineUID: string,
  visited: Set<string>,
  machinesMap: Map<string, Machine>,
  connections: Connection[]
): { flowingMachines: Set<string>; flowingConnections: Set<string> } => {
  // We already been here; return emp
  if (visited.has(currentMachineUID))
    return { flowingMachines: new Set(), flowingConnections: new Set() }

  // Add visited
  visited.add(currentMachineUID)

  // Get machine
  const currentMachine = machinesMap.get(currentMachineUID)

  // Make a set
  let flowingMachines = new Set<string>()
  let flowingConnections = new Set<string>()

  // Stopping statement
  if (currentMachine!.machineType === MACHINE_TYPE.OUTLET) {
    flowingMachines.add(currentMachineUID)
    return { flowingMachines, flowingConnections }
  }

  for (const connection of [
    ...currentMachine!.incomingConnections,
    ...currentMachine!.outgoingConnections,
  ]) {
    if (connection !== EMPTY_CONNECTION) {
      const nextMachineUID = connection
      const {
        flowingMachines: nextFlowingMachines,
        flowingConnections: nextFlowingConnections,
      } = dfsFlowingEntities(nextMachineUID, visited, machinesMap, connections)

      if (
        nextFlowingMachines.size > 0 ||
        machinesMap.get(nextMachineUID)!.machineType === MACHINE_TYPE.OUTLET
      ) {
        flowingConnections.add(currentMachineUID + "->" + nextMachineUID)
        flowingMachines.add(currentMachineUID)

        for (const conn of nextFlowingConnections) {
          flowingConnections.add(conn)
        }
        for (const machine of nextFlowingMachines) {
          flowingMachines.add(machine)
        }
      }
    }
  }

  return { flowingMachines, flowingConnections }
}

const getFlowingEntities = (
  machinesEntries: [string, Machine][],
  allConnections: Connection[]
): { flowingMachines: Set<string>; flowingConnections: Set<string> } => {
  let flowingMachines = new Set<string>()
  let flowingConnections = new Set<string>()

  const machinesMap = new Map<string, Machine>(machinesEntries)
  const visited = new Set<string>()

  for (const [machineUID, machine] of machinesMap) {
    if (machine.machineType === MACHINE_TYPE.INLET && !visited.has(machineUID)) {
      const {
        flowingMachines: nextFlowingMachines,
        flowingConnections: nextFlowingConnections,
      } = dfsFlowingEntities(machineUID, visited, machinesMap, allConnections)

      for (const conn of nextFlowingConnections) {
        flowingConnections.add(conn)
      }
      for (const machine of nextFlowingMachines) {
        flowingMachines.add(machine)
      }
    }
  }

  return { flowingMachines, flowingConnections }
}

const determineMachineState = (
  machineUID: string,
  machinesEntries: [string, SimulatedEntity][],
  allConnections: Connection[]
): CONNECTION_STATE => {
  const { flowingMachines } = getFlowingEntities(
    machinesEntries,
    allConnections
  )

  if (flowingMachines.has(machineUID)) {
    return CONNECTION_STATE.FLOWING
  } else {
    const machineEntry = machinesEntries.find(([id, _]) => id === machineUID)

    const connectedPorts = [
      ...machineEntry[1].incomingConnections,
      ...machineEntry[1].outgoingConnections,
    ].filter(address => address !== EMPTY_CONNECTION)

    return connectedPorts.length > 0
      ? CONNECTION_STATE.CONNECTED
      : CONNECTION_STATE.NONE
  }
}

const determineConnectionState = (
  connection: Connection,
  machinesEntries: [string, Machine][],
  allConnections: Connection[]
): CONNECTION_STATE => {
  const { flowingConnections } = getFlowingEntities(
    machinesEntries,
    allConnections
  )
  return flowingConnections.has(
    connection.sourceMachine + "->" + connection.targetMachine
  )
    ? CONNECTION_STATE.FLOWING
    : CONNECTION_STATE.CONNECTED
}

export const connectionState = (connection: Connection) => {
  return determineConnectionState(
    connection,
    Object.entries(get(simulatedMachines)),
    get(simulatedConnections)
  )
}

export const machineState = (machineId: string) => {
  return determineMachineState(
    machineId,
    Object.entries(get(simulatedMachines)),
    get(simulatedConnections)
  )
}

export function machineTypeToLabel(machineType: MACHINE_TYPE | undefined) {
  if (!machineType) return ""
  switch (machineType || MACHINE_TYPE.NONE) {
    case MACHINE_TYPE.INLET:
      return "INLET"
    case MACHINE_TYPE.OUTLET:
      return "OUTLET"
    case MACHINE_TYPE.PLAYER:
      return "YOU"
    default:
      return MACHINE_TYPE[machineType]
  }
}

export const materialTypeToLabel = (materialType: MATERIAL_TYPE) => {
  return MATERIAL_TYPE[materialType]?.split("_")?.join(" ")
}

