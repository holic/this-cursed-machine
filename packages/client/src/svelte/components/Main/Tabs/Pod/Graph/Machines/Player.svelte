<script lang="ts">
  import { fade } from "svelte/transition"
  import type { GraphMachine } from "../types"
  import { CELL, PLAYER } from "../constants"
  import { DIRECTION } from "@components/Main/Terminal/enums"
  import { GRAPH_ENTITY_STATE } from "@modules/state/simulated/enums"
  import {
    inspecting,
    selectedOption,
    selectedParameters,
  } from "@modules/ui/stores"
  import { networkIsRunning } from "@modules/state/simulated/stores"
  import { MACHINE_TYPE } from "@modules/state/base/enums"
  import { player } from "@modules/state/base/stores"

  export let address: string
  export let machine: GraphMachine
  let selectedPortIndex = -1

  $: producing = machine?.products && machine?.products.length > 0
  $: highlight = $selectedOption?.value === address
  $: disabledHighlight = highlight && $selectedOption?.available === false
  $: {
    if ($selectedParameters) {
      if ($selectedParameters.includes(address)) {
        selectedPortIndex = $selectedOption?.value
      }
    }
  }

  const onMouseEnter = () => {
    if (!producing) return
    inspecting.set(machine)
  }

  const onMouseLeave = () => {
    inspecting.set(null)
  }

  $: style = `background-image: url(/images/machines/${MACHINE_TYPE[machine.machineType]}.png); top: ${CELL.HEIGHT * machine.y}px; left: ${CELL.WIDTH * machine.x}px;`

  function makePorts() {
    return [
      {
        direction: DIRECTION.OUTGOING,
        style: `top: ${CELL.HEIGHT * 4}px; left: ${CELL.WIDTH * (PLAYER.WIDTH - 1)}px;`,
      },
      {
        direction: DIRECTION.OUTGOING,
        style: `top: ${CELL.HEIGHT * 8}px; left: ${CELL.WIDTH * (PLAYER.WIDTH - 1)}px;`,
      },
      {
        direction: DIRECTION.INCOMING,
        style: `top: ${CELL.HEIGHT * 6}px; left: 0px;`,
      },
    ]
  }

  const ports = makePorts()
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<div
  id="machine-{address}"
  class="player run-potential {$networkIsRunning && producing
    ? `running-${Math.floor(Math.random() * 3) + 1}`
    : ''}"
  class:active={machine.state === GRAPH_ENTITY_STATE.ACTIVE}
  class:highlight
  class:disabled-highlight={disabledHighlight}
  on:mouseenter={onMouseEnter}
  on:mouseleave={onMouseLeave}
  in:fade
  {style}
>
  <div class="inner-container">
    <div class="label">{$player.name}</div>
    {#each ports as port, i}
      <div
        class="port"
        class:highlight={selectedPortIndex === i}
        style={port.style}
      />
    {/each}
  </div>
</div>

<style lang="scss">
  .player {
    --playerWidth: 12;
    --playerHeight: 12;
    width: calc(var(--cellWidth) * var(--playerWidth));
    height: calc(var(--cellWidth) * var(--playerHeight));
    font-size: var(--font-size-label);
    display: flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    background-size: cover;
    border: 1px solid var(--background);
    color: var(--foreground);
    cursor: none;

    &.active {
      border: 1px solid var(--color-success);
    }

    .inner-container {
      width: 100%;
      height: 100%;
      position: relative;
      display: flex;
      justify-content: center;
      align-items: center;

      .label {
        position: absolute;
        left: 0;
        background: var(--foreground);
        color: var(--background);
        white-space: nowrap;
        letter-spacing: -1px;
        padding: 2px;
        top: 0;
        transform: translateX(-20px) translateY(-5px);
      }

      .port {
        position: absolute;
        width: var(--cellWidth);
        height: var(--cellHeight);
        background: var(--background);
      }
    }
  }
</style>
