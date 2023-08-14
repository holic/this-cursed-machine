// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { PortType, CarriedBy, EntityType, PortPlacement, CreationBlock } from "../codegen/Tables.sol";
import { ENTITY_TYPE, PORT_TYPE, PORT_PLACEMENT } from "../codegen/Types.sol";
import { LibUtils } from "./LibUtils.sol";

library LibPort {
  /**
   * @dev Creates a new port entity with specified attributes, associates it with a core entity, and sets its placement.
   *
   * The function generates a unique key for the port entity, assigns it the "PORT" entity type, and sets its type and placement.
   * The placements can be one of the following: "TOP", "RIGHT", "BOTTOM", or "LEFT".
   *
   * @param _coreEntity The bytes32 key associated with the core entity to which the port will be linked.
   * @param _portType The type of the port to be created.
   * @param _portPlacement The specific placement of the port, which can be "TOP", "RIGHT", "BOTTOM", or "LEFT".
   *
   * @return Returns the generated key associated with the newly created port entity.
   */
  function create(bytes32 _coreEntity, PORT_TYPE _portType, PORT_PLACEMENT _portPlacement) internal returns (bytes32) {
    bytes32 portEntity = LibUtils.getRandomKey();
    EntityType.set(portEntity, ENTITY_TYPE.PORT);
    CreationBlock.set(portEntity, block.number);
    PortType.set(portEntity, _portType);
    PortPlacement.set(portEntity, _portPlacement);
    CarriedBy.set(portEntity, _coreEntity);
    return portEntity;
  }
}
