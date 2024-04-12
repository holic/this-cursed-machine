// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

uint32 constant TUTORIAL_LEVELS = 4;

uint32 constant ONE_MINUTE = 60;
uint32 constant ONE_HOUR = 60 * 60;
uint32 constant ONE_DAY = 24 * ONE_HOUR;

/// @dev The base rate of material pushed trough the network per block
uint32 constant FLOW_RATE = 1000;
uint32 constant NUMBER_OF_DEPOTS = 3;
/// @dev 4 fixed machines and 10 buildable machines
uint32 constant POD_MACHINE_CAPACITY = 14;
uint32 constant DEPOT_CAPACITY = 50000;
