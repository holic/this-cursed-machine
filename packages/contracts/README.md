# This Cursed Machine

THIS CURSED MACHINE is a sci-fi body horror fulfilment centre simulator. Reverse engineer complex recipes and use your own body as a large scale production circuit. Build strange machines and connect them in intricate supply chains to fulfil orders more quickly than the other workers.

## Concepts

- **Pod:** Container for a player's game. Holds machines, tanks, etc...
- **Network:** Machines and connections that transform materials.
- **Machine:** Node in the network that transforms materials.
- **Player:** Known as _stump_ in the UI. The player's avatar in the game. A machine.
- **Recipe:** Rule for how a machine transforms an input into an output.
- **Tank:** Storage space for materials.
- **Order:** Request for an amount of a material. Player is rewarded with `$BUGS` on fulfilment.  
- **Offer:** A material that can be bought for `$BUGS`. Deposited in a tank.

## Framework

Built with [MUD](https://mud.dev/introduction).

## Overview

The central function is `LibNetwork.resolve`. It reads from tanks connected to the inlets, traverse the network of nodes (machines) and connections, transforming the material in the process. The calculated output is for a single block. 

In `LibTank.write` we then multiply the result by the number of blocks that have passed since the last resolution, taking into account the caps imposed by the available input amounts as well as the limited storage capacity of the output tank. Finally we update the tanks with the new amounts and material types.

We have to run `LibNetwork.resolve` every time the network is changed in a meaningful way (connections made, etc...).

A matching resolve function in the client runs every block to give an impression of continuous transformation in the UI.

## Progression

The player has to pass through a tutorial, completing a series of orders to unlock the full game. At the end of this they can name themselves and have access to the full game.

## Materials and tokens

Materials are represented by `materialId` in the network and in tanks. These are connecteed to ERC20 contracts. `$BUGS` are minted to players on order fulfilment. For user created orders we mint the material to the creator of the order when a player ships it.

## Units

All tokens and material amounts have 18 decimals. In the UI we divide by `1e18` to show the amounts in a more human readable format. Arguments to `createOrder` and and `createOffer` are also in this format. 


