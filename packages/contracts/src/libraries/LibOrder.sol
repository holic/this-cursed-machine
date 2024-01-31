// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;
import { EntityType, Order, OrderData, Tutorial } from "../codegen/index.sol";
import { ENTITY_TYPE, MATERIAL_TYPE, MACHINE_TYPE } from "../codegen/common.sol";
import { LibUtils } from "./LibUtils.sol";

library LibOrder {
  function createOrder(
    MATERIAL_TYPE _resourceMaterial,
    uint32 _resourceAmount,
    MATERIAL_TYPE _goalMaterial,
    uint32 _goalAmount,
    bool _isTutorial,
    uint32 _reward,
    uint32 _duration,
    uint32 _maxPlayers
  ) internal returns (bytes32) {
    bytes32 orderEntity = LibUtils.getRandomKey();
    EntityType.set(orderEntity, ENTITY_TYPE.ORDER);

    Order.set(
      orderEntity,
      OrderData({
        creationBlock: block.number,
        resourceMaterialType: _resourceMaterial,
        resourceAmount: _resourceAmount,
        goalMaterialType: _goalMaterial,
        goalAmount: _goalAmount,
        rewardAmount: _reward,
        maxPlayers: _maxPlayers,
        duration: _duration
      })
    );

    if (_isTutorial) Tutorial.set(orderEntity, true);

    return orderEntity;
  }
}
