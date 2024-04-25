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

struct GameConfigData {
  address adminAddress;
  uint32 globalSpawnIndex;
  uint256 flowRate;
  uint256 tankCapacity;
}

library GameConfig {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "", name: "GameConfig", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x7462000000000000000000000000000047616d65436f6e666967000000000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0058040014042020000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of ()
  Schema constant _keySchema = Schema.wrap(0x0000000000000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (address, uint32, uint256, uint256)
  Schema constant _valueSchema = Schema.wrap(0x0058040061031f1f000000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](0);
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](4);
    fieldNames[0] = "adminAddress";
    fieldNames[1] = "globalSpawnIndex";
    fieldNames[2] = "flowRate";
    fieldNames[3] = "tankCapacity";
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
   * @notice Get adminAddress.
   */
  function getAdminAddress() internal view returns (address adminAddress) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Get adminAddress.
   */
  function _getAdminAddress() internal view returns (address adminAddress) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (address(bytes20(_blob)));
  }

  /**
   * @notice Set adminAddress.
   */
  function setAdminAddress(address adminAddress) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((adminAddress)), _fieldLayout);
  }

  /**
   * @notice Set adminAddress.
   */
  function _setAdminAddress(address adminAddress) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((adminAddress)), _fieldLayout);
  }

  /**
   * @notice Get globalSpawnIndex.
   */
  function getGlobalSpawnIndex() internal view returns (uint32 globalSpawnIndex) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Get globalSpawnIndex.
   */
  function _getGlobalSpawnIndex() internal view returns (uint32 globalSpawnIndex) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint32(bytes4(_blob)));
  }

  /**
   * @notice Set globalSpawnIndex.
   */
  function setGlobalSpawnIndex(uint32 globalSpawnIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((globalSpawnIndex)), _fieldLayout);
  }

  /**
   * @notice Set globalSpawnIndex.
   */
  function _setGlobalSpawnIndex(uint32 globalSpawnIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((globalSpawnIndex)), _fieldLayout);
  }

  /**
   * @notice Get flowRate.
   */
  function getFlowRate() internal view returns (uint256 flowRate) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get flowRate.
   */
  function _getFlowRate() internal view returns (uint256 flowRate) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 2, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set flowRate.
   */
  function setFlowRate(uint256 flowRate) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((flowRate)), _fieldLayout);
  }

  /**
   * @notice Set flowRate.
   */
  function _setFlowRate(uint256 flowRate) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 2, abi.encodePacked((flowRate)), _fieldLayout);
  }

  /**
   * @notice Get tankCapacity.
   */
  function getTankCapacity() internal view returns (uint256 tankCapacity) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Get tankCapacity.
   */
  function _getTankCapacity() internal view returns (uint256 tankCapacity) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 3, _fieldLayout);
    return (uint256(bytes32(_blob)));
  }

  /**
   * @notice Set tankCapacity.
   */
  function setTankCapacity(uint256 tankCapacity) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((tankCapacity)), _fieldLayout);
  }

  /**
   * @notice Set tankCapacity.
   */
  function _setTankCapacity(uint256 tankCapacity) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setStaticField(_tableId, _keyTuple, 3, abi.encodePacked((tankCapacity)), _fieldLayout);
  }

  /**
   * @notice Get the full data.
   */
  function get() internal view returns (GameConfigData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

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
  function _get() internal view returns (GameConfigData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

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
  function set(address adminAddress, uint32 globalSpawnIndex, uint256 flowRate, uint256 tankCapacity) internal {
    bytes memory _staticData = encodeStatic(adminAddress, globalSpawnIndex, flowRate, tankCapacity);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(address adminAddress, uint32 globalSpawnIndex, uint256 flowRate, uint256 tankCapacity) internal {
    bytes memory _staticData = encodeStatic(adminAddress, globalSpawnIndex, flowRate, tankCapacity);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(GameConfigData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.adminAddress,
      _table.globalSpawnIndex,
      _table.flowRate,
      _table.tankCapacity
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(GameConfigData memory _table) internal {
    bytes memory _staticData = encodeStatic(
      _table.adminAddress,
      _table.globalSpawnIndex,
      _table.flowRate,
      _table.tankCapacity
    );

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(
    bytes memory _blob
  ) internal pure returns (address adminAddress, uint32 globalSpawnIndex, uint256 flowRate, uint256 tankCapacity) {
    adminAddress = (address(Bytes.getBytes20(_blob, 0)));

    globalSpawnIndex = (uint32(Bytes.getBytes4(_blob, 20)));

    flowRate = (uint256(Bytes.getBytes32(_blob, 24)));

    tankCapacity = (uint256(Bytes.getBytes32(_blob, 56)));
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
  ) internal pure returns (GameConfigData memory _table) {
    (_table.adminAddress, _table.globalSpawnIndex, _table.flowRate, _table.tankCapacity) = decodeStatic(_staticData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(
    address adminAddress,
    uint32 globalSpawnIndex,
    uint256 flowRate,
    uint256 tankCapacity
  ) internal pure returns (bytes memory) {
    return abi.encodePacked(adminAddress, globalSpawnIndex, flowRate, tankCapacity);
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    address adminAddress,
    uint32 globalSpawnIndex,
    uint256 flowRate,
    uint256 tankCapacity
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(adminAddress, globalSpawnIndex, flowRate, tankCapacity);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple() internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    return _keyTuple;
  }
}
