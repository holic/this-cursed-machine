<script lang="ts">
  import { tweened } from "svelte/motion"
  import { expoIn } from "svelte/easing"
  import { fade } from "svelte/transition"
  import { get } from "svelte/store"
  import { CONNECTION_STATE } from "@modules/state/simulated/enums"
  import { graphPulse } from "@modules/ui/stores"
  import { draw } from "@modules/ui/transitions"
  export let d: string
  export let stroke: string
  export let state: string
  export let transform: string

  const [STROKE, GAP] = [16, 50]

  let freeze = get(graphPulse) * GAP
  const localPulse = tweened(freeze, { duration: 500, easing: expoIn })

  $: $localPulse =
    state === CONNECTION_STATE.FLOWING ? $graphPulse * GAP : freeze * GAP
</script>

<path
  class="path"
  in:draw={{ duration: 500 }}
  out:draw={{ duration: 100 }}
  {d}
  fill="none"
  stroke="var(--STATE_INACTIVE)"
  stroke-width="12"
  {transform}
/>

<!-- in:draw={{ duration: 10000, dasharray: `${STROKE}, ${GAP};` }} -->
<!-- out:draw={{ duration: 10000, dasharray: `${STROKE}, ${GAP};` }} -->
<path
  in:fade={{ duration: 200, delay: 500 }}
  out:fade={{ duration: 100 }}
  class="path"
  {d}
  {stroke}
  {transform}
  fill="none"
  stroke-dasharray="{STROKE}, {GAP}"
  stroke-width={STROKE}
  stroke-dashoffset={$localPulse}
  stroke-linecap="butt"
/>