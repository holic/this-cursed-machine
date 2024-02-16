// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.24;
import { console } from "forge-std/console.sol";
import { BaseTest } from "../../BaseTest.sol";
import "../../../src/codegen/index.sol";
import "../../../src/libraries/Libraries.sol";
import { MACHINE_TYPE, ENTITY_TYPE, MATERIAL_TYPE, PORT_INDEX } from "../../../src/codegen/common.sol";
import { FLOW_RATE } from "../../../src/constants.sol";

contract ResolveSystemTest is BaseTest {
  bytes32 playerEntity;
  bytes32 podEntity;
  bytes32[] inletEntities;
  bytes32 outletEntity;
  bytes32[] depotsInPod;
  FixedEntitiesData fixedEntities;

  function setUp() public override {
    super.setUp();
    vm.startPrank(alice);

    playerEntity = world.spawn();
    world.start();

    podEntity = CarriedBy.get(playerEntity);

    inletEntities = FixedEntities.get(podEntity).inlets;
    outletEntity = FixedEntities.get(podEntity).outlet;

    fixedEntities = FixedEntities.get(podEntity);

    depotsInPod = DepotsInPod.get(podEntity);

    vm.stopPrank();
  }

  function checkProcessing(
    uint32 blocksToWait,
    uint32 divisor,
    uint32 initialInletAmount,
    MATERIAL_TYPE inletMaterialType,
    MATERIAL_TYPE expectedOutputMaterialType
  ) internal {
    // Check inlet material type and amount
    uint32 spentInletMaterial = blocksToWait * FLOW_RATE;
    uint32 remainingInletMaterial = LibUtils.safeSubtract(initialInletAmount, spentInletMaterial);

    // Material type is none if there is no remaining material
    assertEq(
      uint32(MaterialType.get(depotsInPod[0])),
      remainingInletMaterial == 0 ? uint32(MATERIAL_TYPE.NONE) : uint32(inletMaterialType)
    );
    assertEq(Amount.get(depotsInPod[0]), remainingInletMaterial);

    // Check outlet material type and amount
    assertEq(uint32(MaterialType.get(depotsInPod[1])), uint32(expectedOutputMaterialType));
    uint32 producedOutletMaterial = (blocksToWait * FLOW_RATE) / divisor;
    uint32 cappedProducedOutletMaterial = LibUtils.clamp(producedOutletMaterial, (initialInletAmount / divisor));
    assertEq(Amount.get(depotsInPod[1]), cappedProducedOutletMaterial);
  }

  function testResolve() public {
    setUp();

    vm.startPrank(alice);

    // uint32 initialInletAmount = Amount.get(depotsInPod[0]);

    // Connect depot 0 to inlet
    world.attachDepot(depotsInPod[0], fixedEntities.inlets[0]);

    // Connect depot 1 to outlet
    world.attachDepot(depotsInPod[1], fixedEntities.outlet);

    // Connect inlet to outlet
    world.connect(inletEntities[0], outletEntity, PORT_INDEX.FIRST);

    // Wait
    uint32 blocksToWait = 10;
    vm.roll(block.number + blocksToWait);

    // Resolve
    startGasReport("Resolve");
    world.resolve();
    endGasReport();

    vm.stopPrank();

    // uint32 divisor = 1; // Material loss

    // Input
    assertEq(Amount.get(depotsInPod[0]), 1000);
    // Output
    assertEq(Amount.get(depotsInPod[1]), 1000);

    // checkProcessing(blocksToWait, divisor, initialInletAmount, MATERIAL_TYPE.BUG, MATERIAL_TYPE.BUG);
  }

  function testResolveInlet2() public {
    setUp();

    vm.startPrank(alice);

    uint32 initialInletAmount = Amount.get(depotsInPod[0]);

    // Connect depot 0 to inlet 1
    world.attachDepot(depotsInPod[0], fixedEntities.inlets[1]);

    // Connect depot 1 to outlet
    world.attachDepot(depotsInPod[1], fixedEntities.outlet);

    // Connect inlet 1 to outlet
    world.connect(inletEntities[1], outletEntity, PORT_INDEX.FIRST);

    // Wait
    uint32 blocksToWait = 10;
    vm.roll(block.number + blocksToWait);

    // Resolve
    world.resolve();

    vm.stopPrank();

    uint32 divisor = 1; // Material loss

    checkProcessing(blocksToWait, divisor, initialInletAmount, MATERIAL_TYPE.BUG, MATERIAL_TYPE.BUG);
  }

  function testMachineProcessingLoss() public {
    setUp();

    vm.startPrank(alice);

    uint32 initialInletAmount = Amount.get(depotsInPod[0]);

    // Connect depot 0 to inlet
    world.attachDepot(depotsInPod[0], fixedEntities.inlets[0]);

    // Connect depot 0 to outlet
    world.attachDepot(depotsInPod[1], fixedEntities.outlet);

    // Connect inlet to player
    world.connect(inletEntities[0], playerEntity, PORT_INDEX.FIRST);

    // Connect player (piss) to outlet
    world.connect(playerEntity, outletEntity, PORT_INDEX.FIRST);

    // Wait
    uint32 blocksToWait = 30;
    vm.roll(block.number + blocksToWait);

    // Resolve
    world.resolve();

    vm.stopPrank();

    uint32 divisor = 2; // Material loss

    checkProcessing(blocksToWait, divisor, initialInletAmount, MATERIAL_TYPE.BUG, MATERIAL_TYPE.PISS);
  }

  function testDoubleMachineProcessingLoss() public {
    setUp();

    vm.startPrank(alice);

    uint32 initialInletAmount = Amount.get(depotsInPod[0]);

    // Connect depot 0 to inlet
    world.attachDepot(depotsInPod[0], fixedEntities.inlets[0]);

    // Connect depot 1 to outlet
    world.attachDepot(depotsInPod[1], fixedEntities.outlet);

    // Connect inlet to player
    world.connect(inletEntities[0], playerEntity, PORT_INDEX.FIRST);

    // Build splitter
    bytes32 splitterEntity = world.build(MACHINE_TYPE.SPLITTER);

    // Connect player (piss) to splitter
    world.connect(playerEntity, splitterEntity, PORT_INDEX.FIRST);

    // Connect splitter to outlet
    world.connect(splitterEntity, outletEntity, PORT_INDEX.FIRST);

    // Wait
    uint32 blocksToWait = 30;
    vm.roll(block.number + blocksToWait);

    // Resolve
    world.resolve();

    vm.stopPrank();

    uint32 divisor = 4; // Material loss

    checkProcessing(blocksToWait, divisor, initialInletAmount, MATERIAL_TYPE.BUG, MATERIAL_TYPE.PISS);
  }

  function testCapAtInletMaterialAmount() public {
    setUp();

    vm.startPrank(alice);

    uint32 initialInletAmount = Amount.get(depotsInPod[0]);

    // Connect depot 0 to inlet
    world.attachDepot(depotsInPod[0], fixedEntities.inlets[0]);

    // Connect depot 1 to outlet
    world.attachDepot(depotsInPod[1], fixedEntities.outlet);

    // Connect inlet to player
    world.connect(inletEntities[0], playerEntity, PORT_INDEX.FIRST);

    // Connect player (piss) to outlet
    world.connect(playerEntity, outletEntity, PORT_INDEX.FIRST);

    // Wait
    uint32 blocksToWait = 500;
    vm.roll(block.number + blocksToWait);

    // Resolve
    world.resolve();

    vm.stopPrank();

    uint32 divisor = 2; // Material loss

    checkProcessing(blocksToWait, divisor, initialInletAmount, MATERIAL_TYPE.BUG, MATERIAL_TYPE.PISS);
  }

  function testLastResolveValueIsUpdated() public {
    setUp();

    vm.startPrank(alice);

    // Wait
    vm.roll(block.number + 10);

    // Attach depot 0 to inlet
    world.attachDepot(depotsInPod[0], fixedEntities.inlets[0]);

    // Attach depot 1 to outlet
    world.attachDepot(depotsInPod[1], fixedEntities.outlet);

    // Connect inlet to player
    world.connect(inletEntities[0], playerEntity, PORT_INDEX.FIRST);

    // Connect player (piss) to outlet
    world.connect(playerEntity, outletEntity, PORT_INDEX.FIRST);

    // Check that LastResolved was updated
    assertEq(LastResolved.get(podEntity), block.number);

    // * * * * * * * * * * *

    // Wait
    vm.roll(block.number + 10);

    // Detach depot 1 from outlet
    world.detachDepot(depotsInPod[1]);

    // Check that LastResolved was updated
    assertEq(LastResolved.get(podEntity), block.number);

    // * * * * * * * * * * *

    // Wait
    vm.roll(block.number + 10);

    // Attach depot 1 to outlet
    world.attachDepot(depotsInPod[1], fixedEntities.outlet);

    // Check that LastResolved was updated
    assertEq(LastResolved.get(podEntity), block.number);

    // * * * * * * * * * * *

    // Wait
    vm.roll(block.number + 10);

    // Disconnect inlet from player
    world.disconnect(inletEntities[0], PORT_INDEX.FIRST);

    // Check that LastResolved was updated
    assertEq(LastResolved.get(podEntity), block.number);

    vm.stopPrank();
  }
}
