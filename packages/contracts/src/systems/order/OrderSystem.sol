// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;
import { console } from "forge-std/console.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { EntityType, CarriedBy, MaterialType, Order, Amount, CurrentOrder, DepotConnection, Tutorial, TutorialLevel, TutorialOrders, CompletedPlayers, FixedEntities, DepotsInPod } from "../../codegen/index.sol";
import { MACHINE_TYPE, ENTITY_TYPE, MATERIAL_TYPE } from "../../codegen/common.sol";
import { LibUtils, LibOrder, LibToken } from "../../libraries/Libraries.sol";

contract OrderSystem is System {
  function create(
    MATERIAL_TYPE _resourceMaterialType,
    uint32 _resourceAmount,
    MATERIAL_TYPE _goalMaterialType,
    uint32 _goalAmount,
    uint32 _reward,
    uint32 _duration,
    uint32 _maxPlayers
  ) public returns (bytes32) {
    // Todo: Restrict to admin
    // ...
    bytes32 orderEntity = LibOrder.create(
      _resourceMaterialType,
      _resourceAmount,
      _goalMaterialType,
      _goalAmount,
      false, // Not tutorial
      _reward,
      _duration,
      _maxPlayers
    );

    return orderEntity;
  }

  function fill(bytes32 _depotEntity) public {
    bytes32 playerEntity = LibUtils.addressToEntityKey(_msgSender());
    bytes32 podEntity = CarriedBy.get(playerEntity);

    require(CarriedBy.get(_depotEntity) == podEntity, "not in pod");
    require(EntityType.get(_depotEntity) == ENTITY_TYPE.DEPOT, "not depot");
    require(DepotConnection.get(_depotEntity) == bytes32(0), "depot connected");

    bytes32 currentOrder = CurrentOrder.get(podEntity);
    require(currentOrder != bytes32(0), "no order");

    // Check if order goals are met
    require(
      MaterialType.get(_depotEntity) == Order.get(currentOrder).goalMaterialType &&
        Amount.get(_depotEntity) >= Order.get(currentOrder).goalAmount,
      "order not met"
    );

    // Clear depot
    MaterialType.set(_depotEntity, MATERIAL_TYPE.NONE);
    Amount.set(_depotEntity, 0);

    // Handle tutorial levels
    if (Tutorial.get(playerEntity)) {
      uint32 nextTutorialLevel = TutorialLevel.get(playerEntity) + 1;

      if (nextTutorialLevel < TutorialOrders.get().length) {
        // Level up player
        TutorialLevel.set(playerEntity, nextTutorialLevel);
        CurrentOrder.set(podEntity, TutorialOrders.get()[nextTutorialLevel]);

        // Fill depot with tutorial order
        // todo: find first empty depot
        MaterialType.set(DepotsInPod.get(podEntity)[0], Order.get(CurrentOrder.get(podEntity)).resourceMaterialType);
        Amount.set(DepotsInPod.get(podEntity)[0], Order.get(CurrentOrder.get(podEntity)).resourceAmount);
      } else {
        // Tutorial done
        Tutorial.set(playerEntity, false);
        TutorialLevel.deleteRecord(playerEntity);
        CurrentOrder.set(podEntity, bytes32(0));
        // todo: give initial reward
      }

      return;
    }

    // Not in tutorial mode...

    // Add player to completedPlayers list
    CompletedPlayers.push(currentOrder, playerEntity);

    // Clear currentOrder
    CurrentOrder.set(podEntity, bytes32(0));

    // Reward player in tokens
    LibToken.send(_msgSender(), Order.get(currentOrder).rewardAmount);
  }

  function accept(bytes32 _orderEntity) public {
    bytes32 playerEntity = LibUtils.addressToEntityKey(_msgSender());
    bytes32 podEntity = CarriedBy.get(playerEntity);

    require(CurrentOrder.get(podEntity) == bytes32(0), "order in progress");
    require(EntityType.get(_orderEntity) == ENTITY_TYPE.ORDER, "not order");
    require(!Tutorial.get(_orderEntity), "order is tutorial");

    // todo: check that the order is still valid
    // todo: check that the player has not already completed order

    CurrentOrder.set(podEntity, _orderEntity);
  }

  function cancel(bytes32 _orderEntity) public {
    // Todo: Restrict to admin
    Order.deleteRecord(_orderEntity);
    CompletedPlayers.deleteRecord(_orderEntity);
  }

  function buy() public {
    require(LibToken.getTokenBalance(_msgSender()) >= 100, "insufficient balance");

    bytes32 playerEntity = LibUtils.addressToEntityKey(_msgSender());
    // Get player's pod entity
    bytes32 podEntity = CarriedBy.get(playerEntity);

    // 100 Points = 1000 BUGS
    LibToken.transferToken(_world(), _world(), 100);

    bytes32[] memory depotsInPod = DepotsInPod.get(podEntity);

    // Fill first empty depot with 1000 BUGS
    for (uint32 i = 0; i < depotsInPod.length; i++) {
      if (MaterialType.get(depotsInPod[i]) == MATERIAL_TYPE.NONE) {
        MaterialType.set(depotsInPod[i], MATERIAL_TYPE.BUG);
        Amount.set(depotsInPod[i], 1000);
        return;
      }
    }
  }
}