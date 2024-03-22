// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema } from "@latticexyz/store/src/Schema.sol";
import { EncodedLengths, EncodedLengthsLib } from "@latticexyz/store/src/EncodedLengths.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

// Import user types
import { MATERIAL_TYPE } from "./../common.sol";

struct OrderData {
  uint256 creationBlock;
  uint256 expirationBlock;
  MATERIAL_TYPE resourceMaterialType;
  uint32 resourceAmount;
  MATERIAL_TYPE goalMaterialType;
  uint32 goalAmount;
  uint32 rewardAmount;
  uint32 maxPlayers;
}

library Order {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "", name: "Order", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746200000000000000000000000000004f726465720000000000000000000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0052080020200104010404040000000000000000000000000000000000000000);

  // Hex-encoded key schema of (bytes32)
  Schema constant _keySchema = Schema.wrap(0x002001005f000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (uint256, uint256, uint8, uint32, uint8, uint32, uint32, uint32)
  Schema constant _valueSchema = Schema.wrap(0x005208001f1f0003000303030000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "key";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](8);
    fieldNames[0] = "creationBlock";
    fieldNames[1] = "expirationBlock";
    fieldNames[2] = "resourceMaterialType";
    fieldNames[3] = "resourceAmount";
    fieldNames[4] = "goalMaterialType";
    fieldNames[5] = "goalAmount";
    fieldNames[6] = "rewardAmount";
    fieldNames[7] = "maxPlayers";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get creationBlock.
   */
  function getCreationBlock(bytes32 key) internal view returns (uint256 creationBlock) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get creationBlock.
   */
  function _getCreationBlock(bytes32 key) internal view returns (uint256 creationBlock) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set creationBlock.
   */
  function setCreationBlock(bytes32 key, uint256 creationBlock) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((creationBlock)), _fieldLayout);
  }

  /**
   * @notice Set creationBlock.
   */
  function _setCreationBlock(bytes32 key, uint256 creationBlock) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((creationBlock)), _fieldLayout);
  }

  /**
   * @notice Get expirationBlock.
   */
  function getExpirationBlock(bytes32 key) internal view returns (uint256 expirationBlock) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get expirationBlock.
   */
  function _getExpirationBlock(bytes32 key) internal view returns (uint256 expirationBlock) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set expirationBlock.
   */
  function setExpirationBlock(bytes32 key, uint256 expirationBlock) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((expirationBlock)), _fieldLayout);
  }

  /**
   * @notice Set expirationBlock.
   */
  function _setExpirationBlock(bytes32 key, uint256 expirationBlock) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((expirationBlock)), _fieldLayout);
  }

  /**
   * @notice Get resourceMaterialType.
   */
  function getResourceMaterialType(bytes32 key) internal view returns (MATERIAL_TYPE resourceMaterialType) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return MATERIAL_TYPE(uint8(bytes1(_blob)));
  }

  /**
   * @notice Get resourceMaterialType.
   */
  function _getResourceMaterialType(bytes32 key) internal view returns (MATERIAL_TYPE resourceMaterialType) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return MATERIAL_TYPE(uint8(bytes1(_blob)));
  }

  /**
   * @notice Set resourceMaterialType.
   */
  function setResourceMaterialType(bytes32 key, MATERIAL_TYPE resourceMaterialType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked(uint8(resourceMaterialType)), _fieldLayout);
  }

  /**
   * @notice Set resourceMaterialType.
   */
  function _setResourceMaterialType(bytes32 key, MATERIAL_TYPE resourceMaterialType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked(uint8(resourceMaterialType)), _fieldLayout);
  }

  /**
   * @notice Get resourceAmount.
   */
  function getResourceAmount(bytes32 key) internal view returns (uint32 resourceAmount) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Get resourceAmount.
   */
  function _getResourceAmount(bytes32 key) internal view returns (uint32 resourceAmount) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Set resourceAmount.
   */
  function setResourceAmount(bytes32 key, uint32 resourceAmount) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((resourceAmount)), _fieldLayout);
  }

  /**
   * @notice Set resourceAmount.
   */
  function _setResourceAmount(bytes32 key, uint32 resourceAmount) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((resourceAmount)), _fieldLayout);
  }

  /**
   * @notice Get goalMaterialType.
   */
  function getGoalMaterialType(bytes32 key) internal view returns (MATERIAL_TYPE goalMaterialType) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return MATERIAL_TYPE(uint8(bytes1(_blob)));
  }

  /**
   * @notice Get goalMaterialType.
   */
  function _getGoalMaterialType(bytes32 key) internal view returns (MATERIAL_TYPE goalMaterialType) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 4, _fieldLayout);
    return MATERIAL_TYPE(uint8(bytes1(_blob)));
  }

  /**
   * @notice Set goalMaterialType.
   */
  function setGoalMaterialType(bytes32 key, MATERIAL_TYPE goalMaterialType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked(uint8(goalMaterialType)), _fieldLayout);
  }

  /**
   * @notice Set goalMaterialType.
   */
  function _setGoalMaterialType(bytes32 key, MATERIAL_TYPE goalMaterialType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 4, abi.encodePacked(uint8(goalMaterialType)), _fieldLayout);
  }

  /**
   * @notice Get goalAmount.
   */
  function getGoalAmount(bytes32 key) internal view returns (uint32 goalAmount) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Get goalAmount.
   */
  function _getGoalAmount(bytes32 key) internal view returns (uint32 goalAmount) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 5, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Set goalAmount.
   */
  function setGoalAmount(bytes32 key, uint32 goalAmount) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((goalAmount)), _fieldLayout);
  }

  /**
   * @notice Set goalAmount.
   */
  function _setGoalAmount(bytes32 key, uint32 goalAmount) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 5, abi.encodePacked((goalAmount)), _fieldLayout);
  }

  /**
   * @notice Get rewardAmount.
   */
  function getRewardAmount(bytes32 key) internal view returns (uint32 rewardAmount) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Get rewardAmount.
   */
  function _getRewardAmount(bytes32 key) internal view returns (uint32 rewardAmount) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 6, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Set rewardAmount.
   */
  function setRewardAmount(bytes32 key, uint32 rewardAmount) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((rewardAmount)), _fieldLayout);
  }

  /**
   * @notice Set rewardAmount.
   */
  function _setRewardAmount(bytes32 key, uint32 rewardAmount) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 6, abi.encodePacked((rewardAmount)), _fieldLayout);
  }

  /**
   * @notice Get maxPlayers.
   */
  function getMaxPlayers(bytes32 key) internal view returns (uint32 maxPlayers) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Get maxPlayers.
   */
  function _getMaxPlayers(bytes32 key) internal view returns (uint32 maxPlayers) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 7, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Set maxPlayers.
   */
  function setMaxPlayers(bytes32 key, uint32 maxPlayers) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((maxPlayers)), _fieldLayout);
  }

  /**
   * @notice Set maxPlayers.
   */
  function _setMaxPlayers(bytes32 key, uint32 maxPlayers) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setStaticField(_tableId, _keyTuple, 7, abi.encodePacked((maxPlayers)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get(bytes32 key) internal view returns (OrderData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get(bytes32 key) internal view returns (OrderData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(
    bytes32 key,
    uint256 creationBlock,
    uint256 expirationBlock,
    MATERIAL_TYPE resourceMaterialType,
    uint32 resourceAmount,
    MATERIAL_TYPE goalMaterialType,
    uint32 goalAmount,
    uint32 rewardAmount,
    uint32 maxPlayers
  ) internal {
    bytes memory _staticData = encodeStatic(
      creationBlock,
      expirationBlock,
      resourceMaterialType,
      resourceAmount,
      goalMaterialType,
      goalAmount,
      rewardAmount,
      maxPlayers
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    bytes32 key,
    uint256 creationBlock,
    uint256 expirationBlock,
    MATERIAL_TYPE resourceMaterialType,
    uint32 resourceAmount,
    MATERIAL_TYPE goalMaterialType,
    uint32 goalAmount,
    uint32 rewardAmount,
    uint32 maxPlayers
  ) internal {
    bytes memory _staticData = encodeStatic(
      creationBlock,
      expirationBlock,
      resourceMaterialType,
      resourceAmount,
      goalMaterialType,
      goalAmount,
      rewardAmount,
      maxPlayers
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(bytes32 key, OrderData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.creationBlock,
      _table.expirationBlock,
      _table.resourceMaterialType,
      _table.resourceAmount,
      _table.goalMaterialType,
      _table.goalAmount,
      _table.rewardAmount,
      _table.maxPlayers
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(bytes32 key, OrderData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.creationBlock,
      _table.expirationBlock,
      _table.resourceMaterialType,
      _table.resourceAmount,
      _table.goalMaterialType,
      _table.goalAmount,
      _table.rewardAmount,
      _table.maxPlayers
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(
    bytes memory _blob
  )
    internal
    pure
    returns (
      uint256 creationBlock,
      uint256 expirationBlock,
      MATERIAL_TYPE resourceMaterialType,
      uint32 resourceAmount,
      MATERIAL_TYPE goalMaterialType,
      uint32 goalAmount,
      uint32 rewardAmount,
      uint32 maxPlayers
    )
  {
    creationBlock = (uint256(Bytes.getBytes32(_blob, 0)));

    expirationBlock = (uint256(Bytes.getBytes32(_blob, 32)));

    resourceMaterialType = MATERIAL_TYPE(uint8(Bytes.getBytes1(_blob, 64)));

    resourceAmount = (uint32(Bytes.getBytes4(_blob, 65)));

    goalMaterialType = MATERIAL_TYPE(uint8(Bytes.getBytes1(_blob, 69)));

    goalAmount = (uint32(Bytes.getBytes4(_blob, 70)));

    rewardAmount = (uint32(Bytes.getBytes4(_blob, 74)));

    maxPlayers = (uint32(Bytes.getBytes4(_blob, 78)));
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   *
   *
   */
  function decode(
    bytes memory _staticData,
    EncodedLengths,
    bytes memory
  ) internal pure returns (OrderData memory _table) {
    (
      _table.creationBlock,
      _table.expirationBlock,
      _table.resourceMaterialType,
      _table.resourceAmount,
      _table.goalMaterialType,
      _table.goalAmount,
      _table.rewardAmount,
      _table.maxPlayers
    ) = decodeStatic(_staticData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(bytes32 key) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(bytes32 key) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    uint256 creationBlock,
    uint256 expirationBlock,
    MATERIAL_TYPE resourceMaterialType,
    uint32 resourceAmount,
    MATERIAL_TYPE goalMaterialType,
    uint32 goalAmount,
    uint32 rewardAmount,
    uint32 maxPlayers
  ) internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        creationBlock,
        expirationBlock,
        resourceMaterialType,
        resourceAmount,
        goalMaterialType,
        goalAmount,
        rewardAmount,
        maxPlayers
      );
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    uint256 creationBlock,
    uint256 expirationBlock,
    MATERIAL_TYPE resourceMaterialType,
    uint32 resourceAmount,
    MATERIAL_TYPE goalMaterialType,
    uint32 goalAmount,
    uint32 rewardAmount,
    uint32 maxPlayers
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(
      creationBlock,
      expirationBlock,
      resourceMaterialType,
      resourceAmount,
      goalMaterialType,
      goalAmount,
      rewardAmount,
      maxPlayers
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(bytes32 key) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = key;

    return _keyTuple;
  }
}
