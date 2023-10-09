// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;
import { System } from "@latticexyz/world/src/System.sol";
import { GameConfig, GameConfigData } from "../codegen/index.sol";
import { LibLevel, LibRecipe, LibUtils } from "../libraries/Libraries.sol";
import { LevelDefinition } from "../constants.sol";
import { MACHINE_TYPE, MATERIAL_TYPE } from "../codegen/common.sol";

contract InitSystem is System {
  /**
   * @notice Initializes the game configuration and creates initial level definitions.
   * @dev Ensure that the system is not initialized more than once by checking the 'coolDown' in GameConfig.
   */
  function init() public {
    require(GameConfig.get().coolDown == 0, "InitSystem: already initialized");

    // Set game config
    GameConfig.set(GameConfigData({ coolDown: 1, connectionCost: 10, buildCost: 20 }));

    // Create levels
    LevelDefinition[7] memory levels = [
      LevelDefinition({ level: 1, initialCoreEnergy: 100 }),
      LevelDefinition({ level: 2, initialCoreEnergy: 100 }),
      LevelDefinition({ level: 3, initialCoreEnergy: 100 }),
      LevelDefinition({ level: 4, initialCoreEnergy: 100 }),
      LevelDefinition({ level: 5, initialCoreEnergy: 100 }),
      LevelDefinition({ level: 6, initialCoreEnergy: 100 }),
      LevelDefinition({ level: 7, initialCoreEnergy: 100 })
    ];

    for (uint256 i = 0; i < levels.length; i++) {
      LibLevel.create(levels[i]);
    }

    // Cooler recipes
    LibRecipe.create(MACHINE_TYPE.COOLER, uint256(MATERIAL_TYPE.MONSTER), MATERIAL_TYPE.BUG);
    LibRecipe.create(MACHINE_TYPE.COOLER, uint256(MATERIAL_TYPE.BLOOD_LIPIDS), MATERIAL_TYPE.BLOOD);
    LibRecipe.create(MACHINE_TYPE.COOLER, uint256(MATERIAL_TYPE.M150), MATERIAL_TYPE.PRIME);
    LibRecipe.create(MACHINE_TYPE.COOLER, uint256(MATERIAL_TYPE.PRIME), MATERIAL_TYPE.DIET_RED_BULL);
    LibRecipe.create(MACHINE_TYPE.COOLER, uint256(MATERIAL_TYPE.CAFFEINATED_HEMATURIC_LIQUID), MATERIAL_TYPE.CLUB_MATE);
    LibRecipe.create(MACHINE_TYPE.COOLER, uint256(MATERIAL_TYPE.DIET_RED_BULL), MATERIAL_TYPE.CLUB_MATE);

    // Wetter recipes
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.BUG), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.DIRT), MATERIAL_TYPE.PLANT);
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.BLOOD_LIPIDS), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.M150), MATERIAL_TYPE.PRIME);
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.PLANT), MATERIAL_TYPE.CLUB_MATE);
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.E_LIQUID), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.TOBACCO), MATERIAL_TYPE.CIGARETTE_JUICE);
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.CIGARETTE_JUICE), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.HAND_OF_GOD), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.WETTER, uint256(MATERIAL_TYPE.FIVE_HOUR_ENERGY), MATERIAL_TYPE.SLUDGE);

    // Dryer recipes
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.MONSTER), MATERIAL_TYPE.BUG);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.PISS), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.FIVE_HOUR_ENERGY), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.CAFFEINATED_HEMATURIC_LIQUID), MATERIAL_TYPE.DIRT);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.CLUB_MATE), MATERIAL_TYPE.DIRT);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.BLOOD_LIPIDS), MATERIAL_TYPE.DIRT);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.SLUDGE), MATERIAL_TYPE.DIRT);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.PLANT), MATERIAL_TYPE.TOBACCO);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.E_LIQUID), MATERIAL_TYPE.TOBACCO);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.CIGARETTE_JUICE), MATERIAL_TYPE.TOBACCO);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.DIET_RED_BULL), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.HAND_OF_GOD), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.DRYER, uint256(MATERIAL_TYPE.PRIME), MATERIAL_TYPE.SLUDGE);

    // Boiler recipes
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.BUG), MATERIAL_TYPE.MONSTER);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.PISS), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.BLOOD), MATERIAL_TYPE.BLOOD_LIPIDS);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.DIRT), MATERIAL_TYPE.BLOOD_LIPIDS);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.BLOOD_LIPIDS), MATERIAL_TYPE.DIRT);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.CAFFEINATED_HEMATURIC_LIQUID), MATERIAL_TYPE.PRIME);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.PLANT), MATERIAL_TYPE.CLUB_MATE);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.CLUB_MATE), MATERIAL_TYPE.DIET_RED_BULL);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.PRIME), MATERIAL_TYPE.M150);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.FIVE_HOUR_ENERGY), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.DIET_RED_BULL), MATERIAL_TYPE.PRIME);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.TOBACCO), MATERIAL_TYPE.CIGARETTE_JUICE);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.CIGARETTE_JUICE), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.HAND_OF_GOD), MATERIAL_TYPE.SLUDGE);
    LibRecipe.create(MACHINE_TYPE.BOILER, uint256(MATERIAL_TYPE.E_LIQUID), MATERIAL_TYPE.SLUDGE);

    // Mixer recipes

    // BLOOD + PISS => CAFFEINATED_HEMATURIC_LIQUID
    LibRecipe.create(
      MACHINE_TYPE.MIXER,
      LibUtils.getUniqueIdentifier(uint8(MATERIAL_TYPE.BLOOD), uint8(MATERIAL_TYPE.PISS)),
      MATERIAL_TYPE.CAFFEINATED_HEMATURIC_LIQUID
    );

    // PISS + MONSTER => M150
    LibRecipe.create(
      MACHINE_TYPE.MIXER,
      LibUtils.getUniqueIdentifier(uint8(MATERIAL_TYPE.PISS), uint8(MATERIAL_TYPE.MONSTER)),
      MATERIAL_TYPE.M150
    );

    // PISS + M150 => FIVE_HOUR_ENERGY
    LibRecipe.create(
      MACHINE_TYPE.MIXER,
      LibUtils.getUniqueIdentifier(uint8(MATERIAL_TYPE.PISS), uint8(MATERIAL_TYPE.M150)),
      MATERIAL_TYPE.FIVE_HOUR_ENERGY
    );

    // PRIME + M150 => FIVE_HOUR_ENERGY
    LibRecipe.create(
      MACHINE_TYPE.MIXER,
      LibUtils.getUniqueIdentifier(uint8(MATERIAL_TYPE.PRIME), uint8(MATERIAL_TYPE.M150)),
      MATERIAL_TYPE.FIVE_HOUR_ENERGY
    );

    // BLOOD_LIPIDS + CIGARETTE_JUICE => E_LIQUID
    LibRecipe.create(
      MACHINE_TYPE.MIXER,
      LibUtils.getUniqueIdentifier(uint8(MATERIAL_TYPE.BLOOD_LIPIDS), uint8(MATERIAL_TYPE.CIGARETTE_JUICE)),
      MATERIAL_TYPE.E_LIQUID
    );

    // DIET_RED_BULL + CIGARETTE_JUICE => E_LIQUID
    LibRecipe.create(
      MACHINE_TYPE.MIXER,
      LibUtils.getUniqueIdentifier(uint8(MATERIAL_TYPE.DIET_RED_BULL), uint8(MATERIAL_TYPE.CIGARETTE_JUICE)),
      MATERIAL_TYPE.E_LIQUID
    );

    // FIVE_HOUR_ENERGY + E_LIQUID => HAND_OF_GOD
    LibRecipe.create(
      MACHINE_TYPE.MIXER,
      LibUtils.getUniqueIdentifier(uint8(MATERIAL_TYPE.FIVE_HOUR_ENERGY), uint8(MATERIAL_TYPE.E_LIQUID)),
      MATERIAL_TYPE.HAND_OF_GOD
    );
  }
}
