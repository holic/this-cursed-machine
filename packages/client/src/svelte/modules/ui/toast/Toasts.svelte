<script lang="ts">
  import type { Toast } from "."
  import { toasts } from "."
  import ToastComponent from "./Toast.svelte"
  import { fade } from "svelte/transition"
  import { flip } from "svelte/animate"

  const onEnd = (e: CustomEvent<Toast>) => {
    toasts.set($toasts.filter((t: Toast) => t.timestamp !== e.detail.timestamp))
  }
</script>

<div class="toast-pane">
  {#each $toasts as toast (toast.timestamp)}
    <div animate:flip in:fade={{ duration: 100 }} out:fade={{ duration: 300 }}>
      <ToastComponent {toast} on:end={onEnd} />
    </div>
  {/each}
</div>

<style>
  .toast-pane {
    position: absolute;
    z-index: var(--z-9);
    top: 10px;
    right: 10px;
    display: flex;
    flex-direction: column-reverse;
    width: 300px;
    text-align: center;
  }
</style>
