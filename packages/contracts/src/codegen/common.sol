// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */
enum ENTITY_TYPE {
  NONE,
  BOX,
  MACHINE,
  CONNECTION,
  MATERIAL,
  PORT
}

enum MACHINE_TYPE {
  BLOCKER,
  INLET,
  OUTLET,
  CORE,
  BLENDER,
  SPLITTER,
  SCORCHER,
  COMBI_GATE
}

enum MATERIAL_TYPE {
  NONE,
  PELLET,
  BLOOD,
  PISS,
  DIRT,
  SAND,
  FLESH,
  TEETH
}

enum CONNECTION_TYPE {
  CONTROL,
  RESOURCE
}

enum PORT_TYPE {
  INPUT,
  OUTPUT
}

enum PORT_PLACEMENT {
  TOP,
  RIGHT,
  BOTTOM,
  LEFT
}
