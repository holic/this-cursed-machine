// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

uint32 constant NUMBER_OF_TUTORIAL_LEVELS = 3;

/// @dev Material amounts and token have 18 decimals
uint256 constant ONE_UNIT = 1e18;

uint32 constant ONE_MINUTE = 60;
uint32 constant ONE_HOUR = 60 * 60;
uint32 constant ONE_DAY = 24 * ONE_HOUR;

/// @dev Four fixed machines and ten buildable machines
uint32 constant POD_MACHINE_CAPACITY = 14;
uint32 constant NUMBER_OF_TANKS = 3;
/// @dev The base rate of material pushed trough the network per block
uint256 constant FLOW_RATE = 10 * ONE_UNIT;
uint256 constant TANK_CAPACITY = 500 * ONE_UNIT;
