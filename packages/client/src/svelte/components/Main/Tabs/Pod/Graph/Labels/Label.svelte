<script lang="ts">
  import { materialMetadata } from "@svelte/modules/state/base/stores"
  import type { GraphConnection } from "../types"
  import { CELL } from "../constants"
  import { getLongestSection } from "../Connections/svg"
  import { displayAmount } from "@modules/utils"

  export let connection: GraphConnection
  export let hover: boolean
  export let carrying: boolean
  export let productive: boolean
  export let pathElement: SVGPathElement
  // Putting the visibility toggle here because of this issue:
  // https://github.com/sveltejs/svelte/issues/6479
  export let visible: boolean

  let words = []
  // let frameId: number

  let [labelX, labelY] = [0, 0]
  // let zeroOrOne = tweened(0, { easing })
  // let zeroOrOne = 1

  let dir = 0
  let direction = ""

  $: material = $materialMetadata[connection?.products?.[0]?.materialId]?.name
  $: amount = displayAmount(connection?.products?.[0]?.amount)

  $: {
    if (material && amount && direction) {
      words = [`${direction} ${material} ${direction}`]
    }
    if (direction) {
      words = [`${direction} none ${direction}`]
    }
  }

  $: {
    if (pathElement) {
      const [x, y, d] = getLongestSection(connection, CELL.HEIGHT, CELL.WIDTH)

      const dirs = ["→", "→", "←", "←"]

      labelX = x
      labelY = y
      dir = d
      direction = dirs[d]
    }
  }
</script>

<text
  text-anchor="middle"
  x={labelX}
  y={labelY}
  class:hover
  class:carrying
  class:productive
  class:visible
  class="label"
  class:vertical={dir === 1 || dir === 3}
>
  {#key material}
    {`${direction} ${material || "EMPTY"} ${direction}`}
  {/key}
</text>

<style lang="scss">
  .label {
    font-size: 7px;
    font-family: var(--font-family);
    transform-box: fill-box;
    transform-origin: center;
    transform: translate(0, 8px);
    text-align: center;
    stroke-width: 3;
    paint-order: stroke;
    stroke: var(--color-grey-mid);
    white-space: pre;
    fill: var(--color-grey-light);

    opacity: 0;
    &.visible {
      opacity: 1;
    }

    &.carrying {
      fill: var(--white);

      &.productive {
        fill: var(--color-success);
      }
    }

    &.hover {
      display: none;
    }

    &.vertical {
      transform: translate(4px, 0) rotate(90deg);
    }
  }
</style>
