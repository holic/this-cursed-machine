import { mudConfig } from "@latticexyz/world/register";
import { resolveTableId } from "@latticexyz/config";

export const enums = {
    ENTITY_TYPE: ["NONE", "RECIPE", "LEVEL", "GOAL", "BOX", "MACHINE", "CONNECTION", "MATERIAL", "PORT"],
    MACHINE_TYPE: ["NONE", "INLET", "OUTLET", "CORE", "SPLITTER", "MIXER", "DRYER", "WETTER", "BOILER", "COOLER"],
    MATERIAL_TYPE: ["NONE", "BUG", "PISS", "BLOOD", "SLUDGE", "DIRT", "BLOOD_LIPIDS", "PLANT", "CAFFEINATED_HEMATURIC_LIQUID", "CLUB_MATE", "DIET_RED_BULL", "PRIME", "M150", "FIVE_HOUR_ENERGY", "MONSTER", "E_LIQUID", "TOBACCO", "CIGARETTE_JUICE", "HAND_OF_GOD"],
    PORT_TYPE: ["INPUT", "OUTPUT"]
}

export default mudConfig({
    deploysDirectory: "./deploys",
    enums,
    tables: {
        EntityType: "ENTITY_TYPE",
        MachineType: "MACHINE_TYPE",
        MaterialType: "MATERIAL_TYPE",
        PortType: "PORT_TYPE",
        Name: "string",
        Energy: "uint32",
        CarriedBy: "bytes32",
        Amount: "uint32",
        SourcePort: "bytes32",
        TargetPort: "bytes32",
        CreationBlock: "uint256",
        ReadyBlock: "uint256",
        Level: "uint32",
        LastResolved: "uint256",
        Input: "uint256",
        Output: "MATERIAL_TYPE",
        // ...
        GameConfig: {
            keySchema: {},
            valueSchema: {
                coolDown: "uint32",
                connectionCost: "uint32",
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
            args: [resolveTableId("MachineType")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("MaterialType")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("Level")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("CarriedBy")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("PortType")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("SourcePort")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("Input")],
        },
    ],
});
