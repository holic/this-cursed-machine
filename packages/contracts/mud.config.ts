import { mudConfig } from "@latticexyz/world/register";
import { resolveTableId } from "@latticexyz/config";
/**
 * Importing this enables "snap sync mode".
 * It allows clients to sync the latest state of the world using view functions.
 * This is a simple way to quickly sync without the use of an external indexer.
 * This could lead to expensive queries on live RPCs if the world is large,
 * so we suggest using MODE for production deployments.
 */
// import "@latticexyz/world/snapsync";

export default mudConfig({
    snapSync: false,
    deploysDirectory: "./deploys",
    namespace: "mc",
    enums: {
        ENTITY_TYPE: ["BOX", "CORE", "MACHINE", "CONNECTION", "RESOURCE", "PORT", "CLAIM"],
        MACHINE_TYPE: ["BLOCKER", "SPLITTER", "COMBINATOR", "MIXER", "FILTER", "SHOWER", "DRYER", "HEATER", "FREEZER", "GRINDER"],
        RESOURCE_TYPE: ["PELLET", "DIRT", "PISS", "BLOOD"],
        CONNECTION_TYPE: ["CONTROL", "RESOURCE"],
        PORT_TYPE: ["INPUT", "OUTPUT"],
        PORT_PLACEMENT: ["TOP", "RIGHT", "BOTTOM", "LEFT"]
    },
    tables: {
        EntityType: "ENTITY_TYPE",
        MachineType: "MACHINE_TYPE",
        ResourceType: "RESOURCE_TYPE",
        ConnectionType: "CONNECTION_TYPE",
        PortType: "PORT_TYPE",
        // ...
        Name: "string",
        CarriedBy: "bytes32",
        IsPrototype: "bool",
        // ...
        Width: "int32",
        Height: "int32",
        // ...
        PortPlacement: "PORT_PLACEMENT",
        // ...
        SourcePort: "bytes32",
        TargetPort: "bytes32",
        // ...
        CreationBlock: "uint256",
        ReadyBlock: "uint256",
        ClaimBlock: "uint256",
        // ...
        MinCores: "uint32",
        MaxCores: "uint32",
        Level: "uint32",
        Active: "bool",
        // ...
        Position: {
            schema: {
                x: "int32",
                y: "int32",
            },
        },
        // ...
        GameConfig: {
            keySchema: {},
            schema: {
                coolDown: "uint32",
                coreEnergyCap: "uint32",
                coreInitialEnergy: "uint32",
                resourceConnectionCost: "uint32",
                controlConnectionCost: "uint32",
                buildCost: "uint32",
            },
            dataStruct: true,
        },
    },
    modules: [
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("EntityType")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("Level")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("Active")],
        },
        // {
        //     name: "KeysWithValueModule",
        //     root: true,
        //     args: [resolveTableId("Position")],
        // },
        // {
        //     name: "KeysInTableModule",
        //     root: true,
        //     args: [resolveTableId("ClaimBlock")],
        // }
    ],
});
