<script lang="ts">
  import type { GraphMachine } from "../types"
  import { fade } from "svelte/transition"
  import { materialMetadata } from "@modules/state/base/stores"
  import { MACHINE_TYPE } from "@modules/state/base/enums"
  import { machineTypeToActionVerbs } from "@modules/state/simulated"
  import { CELL, MACHINE } from "../constants"
  import { DIRECTION } from "@components/Main/Terminal/enums"
  import { PLACEMENT_GROUP } from "../enums"
  import { GRAPH_ENTITY_STATE } from "@modules/state/simulated/enums"
  import { networkIsRunning } from "@modules/state/simulated/stores"
  import {
    inspecting,
    selectedOption,
    selectedParameters,
  } from "@modules/ui/stores"

  import TweenedText from "@components/Main/Tabs/Pod/Graph/Labels/TweenedText.svelte"

  export let address: string
  export let machine: GraphMachine

  let selectedPortIndex = -1
  let highlight = false

  const onMouseEnter = () => {
    if (!producing) return
    inspecting.set(machine)
  }

  const onMouseLeave = () => {
    inspecting.set(null)
  }

  $: producing = machine?.products && machine?.products.length > 0
  $: style = `background-image: url(/images/machines/${MACHINE_TYPE[machine.machineType]}.png); top: ${CELL.HEIGHT * machine.y}px; left: ${CELL.WIDTH * machine.x}px;`
  $: label = `${MACHINE_TYPE[machine.machineType]} ${machine.buildIndex ?? ""}`
  $: highlight = $selectedOption?.value === address
  $: disabledHighlight = highlight && $selectedOption?.available === false
  $: {
    if ($selectedParameters) {
      if ($selectedParameters.includes(address)) {
        selectedPortIndex = $selectedOption?.value
      }
    }
  }
  $: verticalLabel1 =
    machine.placementGroup === PLACEMENT_GROUP.TOP
      ? `transform: translate(-50%, -100%) translateY(-4px)`
      : `transform: translate(-50%, 100%) translateY(0px)`
  $: verticalLabel2 =
    machine.placementGroup === PLACEMENT_GROUP.TOP
      ? `transform: translate(-50%, -200%) translateY(-8px)`
      : `transform: translate(-50%, 200%) translateY(4px)`

  function makePorts(machine: GraphMachine) {
    const verticalPosition =
      machine.placementGroup === PLACEMENT_GROUP.TOP
        ? (MACHINE.HEIGHT - 1) * CELL.HEIGHT
        : 0

    // Helper to fetch the correct material data
    const getPortMaterial = (index: 0 | 1) => {
      if (machine?.products && machine?.products.length > 0) {
        if (!machine.products[index]) return undefined

        const id = machine.products[index].materialId

        return $materialMetadata[id]
      }

      return undefined
    }

    const mat0 = getPortMaterial(0) || undefined
    const mat1 = getPortMaterial(1) || undefined

    if (
      machine.machineType === MACHINE_TYPE.SPLITTER ||
      machine.machineType === MACHINE_TYPE.CENTRIFUGE ||
      machine.machineType === MACHINE_TYPE.GRINDER ||
      machine.machineType === MACHINE_TYPE.RAT_CAGE ||
      machine.machineType === MACHINE_TYPE.MEALWORM_VAT
    ) {
      return [
        {
          direction: DIRECTION.OUTGOING,
          style: `top: ${verticalPosition}px; left: ${CELL.WIDTH * 4}px;`,
          label: mat0?.title || "",
          labelStyle: `top: ${verticalPosition}px; left: ${CELL.WIDTH * 4}px; ${verticalLabel1}; width: ${Math.min(mat0?.title?.length, 12)};`,
        },
        {
          direction: DIRECTION.OUTGOING,
          style: `top: ${verticalPosition}px; left: ${CELL.WIDTH * 6}px;`,
          label: mat1?.title || "",
          labelStyle: `top: ${verticalPosition}px; left: ${CELL.WIDTH * 6}px; ${mat0 ? verticalLabel2 : verticalLabel1}; width: ${Math.min(mat1?.title?.length, 12)};`,
        },
        {
          direction: DIRECTION.INCOMING,
          style: `top: ${verticalPosition}px; left: ${CELL.WIDTH}px;`,
        },
      ]
    } else if (machine.machineType === MACHINE_TYPE.MIXER) {
      return [
        {
          direction: DIRECTION.INCOMING,
          style: `top: ${verticalPosition}px; left: 0px;`,
        },
        {
          direction: DIRECTION.INCOMING,
          style: `top: ${verticalPosition}px; left: ${CELL.WIDTH * 2}px;`,
        },
        {
          direction: DIRECTION.OUTGOING,
          label: mat0?.title || "",
          style: `top: ${verticalPosition}px; left: ${CELL.WIDTH * 5}px;`,
          labelStyle: `top: ${verticalPosition}px; left: ${CELL.WIDTH * 5}px; ${verticalLabel1}; width: ${Math.min(mat0?.title?.length, 12)};`,
        },
      ]
    } else {
      return [
        {
          direction: DIRECTION.INCOMING,
          style: `top: ${verticalPosition}px; left: ${CELL.WIDTH}px;`,
        },
        {
          direction: DIRECTION.OUTGOING,
          label: mat0?.title || "",
          style: `top: ${verticalPosition}px; left: ${CELL.WIDTH * 5}px;`,
          labelStyle: `top: ${verticalPosition}px; left: ${CELL.WIDTH * 5}px; ${verticalLabel1}; width: ${Math.min(mat0?.title?.length, 12)};`,
        },
      ]
    }
  }

  $: ports = makePorts(machine)
</script>

<!-- svelte-ignore a11y-interactive-supports-focus -->
<div
  id="machine-{address}"
  class="machine run-potential {MACHINE_TYPE[
    machine.machineType
  ]} {$networkIsRunning && machine.productive
    ? `running-${Math.floor(Math.random() * 3) + 1}`
    : ''}"
  class:active={machine.state === GRAPH_ENTITY_STATE.ACTIVE}
  class:highlight
  class:disabled-highlight={disabledHighlight}
  on:mouseenter={onMouseEnter}
  on:mouseleave={onMouseLeave}
  in:fade
  {style}
  role="button"
>
  <div class="inner-container">
    <div
      class="label"
      class:top={machine.placementGroup == PLACEMENT_GROUP.TOP}
      class:bottom={machine.placementGroup == PLACEMENT_GROUP.BOTTOM}
    >
      <TweenedText
        duration={300}
        delay={1000}
        words={producing
          ? [label, "@", ...machineTypeToActionVerbs(machine.machineType)]
          : [label]}
      />
    </div>
    {#each ports as port, i}
      {#if port.direction === DIRECTION.OUTGOING && port.label !== ""}
        <div class="port-label" style={port.labelStyle}>
          {port.label}
        </div>
      {/if}
      <div
        class:highlight={selectedPortIndex === i}
        class:disabled-highlight={selectedPortIndex === i &&
          $selectedOption?.available === false}
        class="port {DIRECTION[port.direction]}"
        style={port.style}
      />
    {/each}
  </div>
</div>

<style lang="scss">
  .machine {
    --machineWidth: 8;
    --machineHeight: 8;
    width: calc(var(--cellWidth) * 8);
    height: calc(var(--cellWidth) * 8);
    font-size: var(--font-size-label);
    display: flex;
    justify-content: center;
    align-items: center;
    background: var(--color-grey-dark);
    position: absolute;
    color: var(--background);
    background-size: cover;
    border: 1px solid var(--background);

    &.active {
      border: 1px solid var(--color-success);
      cursor: none;
    }

    .inner-container {
      width: 100%;
      height: 100%;
      position: relative;

      .label {
        position: absolute;
        left: 0;
        background: var(--foreground);
        color: var(--background);
        white-space: nowrap;
        letter-spacing: -1px;
        padding: 2px;

        &.top {
          top: 0;
          transform: translateX(-20px) translateY(-5px);
        }

        &.bottom {
          bottom: 0;
          transform: translateX(-20px) translateY(5px);
        }
      }

      .port-label {
        position: absolute;
        background: var(--color-grey-light);
        color: var(--color-grey-dark);
        opacity: 1;
        display: block;
        padding: 3px;
        text-align: center;
      }
      .port {
        position: absolute;
        width: var(--cellWidth);
        height: var(--cellHeight);
        background: var(--color-grey-dark);
        opacity: 1;
      }
    }
  }
</style>
