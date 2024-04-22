// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;
import { console } from "forge-std/console.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { GameConfig, EntityType, CarriedBy, MaterialType, Order, OrderData, Amount, CurrentOrder, TankConnection, Tutorial, TutorialLevel, Completed, OutgoingConnections, IncomingConnections } from "../../codegen/index.sol";
import { MACHINE_TYPE, ENTITY_TYPE, MATERIAL_TYPE } from "../../codegen/common.sol";
import { LibUtils, LibOrder, LibNetwork, PublicMaterials } from "../../libraries/Libraries.sol";
import { ArrayLib } from "@latticexyz/world-modules/src/modules/utils/ArrayLib.sol";
import { NUMBER_OF_TUTORIAL_LEVELS, TANK_CAPACITY, ONE_TOKEN_UNIT } from "../../constants.sol";

contract OrderSystem is System {
  /**
   * @notice Create an order
   * @dev Free for admin, charges reward cost (_reward * _maxPlayers) for non-admin
   * @param _title Title of the order
   * @param _materialType Material type to produce
   * @param _amount Amount to produce
   * @param _reward Reward for completing the order in whole token units (1 token = 1e18)
   * @param _duration Duration of the order
   * @param _maxPlayers Maximum number of players that can accept the order
   * @return orderEntity Id of the offer entity
   */
  function createOrder(
    string memory _title,
    MATERIAL_TYPE _materialType,
    uint32 _amount,
    uint32 _reward,
    uint32 _duration,
    uint32 _maxPlayers
  ) public returns (bytes32 orderEntity) {
    require(_maxPlayers > 0, "max players must be greater than 0");
    // @todo: limit title length

    // If the caller is not admin, we charge for the reward cost
    if (_msgSender() != GameConfig.getAdminAddress()) {
      uint32 totalRewardCost = _reward * _maxPlayers;
      require(
        PublicMaterials.BUG.getTokenBalance(_msgSender()) >= totalRewardCost * ONE_TOKEN_UNIT,
        "insufficient funds"
      );
      PublicMaterials.BUG.transferToken(_world(), totalRewardCost * ONE_TOKEN_UNIT);
    }

    orderEntity = LibOrder.create(
      LibUtils.addressToEntityKey(_msgSender()),
      _title,
      _materialType,
      _amount,
      false, // Not tutorial
      0, // Not tutorial
      _reward,
      _duration,
      _maxPlayers
    );

    return orderEntity;
  }

  /**
   * @notice Cancel an order
   * @dev Restricted to admin
   * @param _orderEntity Id of the order entity
   */
  function cancelOrder(bytes32 _orderEntity) public {
    //  Restrict to admin
    require(_msgSender() == GameConfig.getAdminAddress(), "not allowed");

    Order.deleteRecord(_orderEntity);
    Completed.deleteRecord(_orderEntity);
  }

  /**
   * @notice Accept an order
   * @dev This simply indicates that a user is committed to an order
   * @param _orderEntity Id of the order entity
   */
  function acceptOrder(bytes32 _orderEntity) public {
    bytes32 playerEntity = LibUtils.addressToEntityKey(_msgSender());

    require(EntityType.get(_orderEntity) == ENTITY_TYPE.ORDER, "not order");

    if (Tutorial.get(playerEntity)) {
      // A player in tutorial mode cannot accept a non-tutorial order
      require(Tutorial.get(_orderEntity), "not tutorial order");

      uint32 playerTutorialLevel = TutorialLevel.get(playerEntity);
      require(playerTutorialLevel == TutorialLevel.get(_orderEntity), "wrong tutorial level");
    }

    OrderData memory currentOrder = Order.get(_orderEntity);

    require(currentOrder.expirationBlock == 0 || block.number < currentOrder.expirationBlock, "order expired");
    require(!ArrayLib.includes(Completed.get(_orderEntity), playerEntity), "order already completed");

    CurrentOrder.set(playerEntity, _orderEntity);
  }

  /**
   * @notice Unaccept the current order
   */
  function unacceptOrder() public {
    bytes32 playerEntity = LibUtils.addressToEntityKey(_msgSender());
    CurrentOrder.set(playerEntity, bytes32(0));
  }
}
