import { readable, writable, derived } from "svelte/store"

// Write markdown
export const wiki = readable({
  machines: {
    BLOCKER: `### BLOCKER`,
    SPLITTER: `### SPLITTER`,
    COMBINATOR: `### COMBINATOR`,
    MIXER: `### MIXER`,
    FILTER: `### FILTER`,
    SHOWER: `### SHOWER`,
    DRYER: `### DRYER`,
    HEATER: `### HEATER`,
    FREEZER: `### FREEZER`,
    GRINDER: `### GRINDER`
  }
})

export const explainer = writable("")

export const  machineExplanation = derived([explainer, wiki], ([$explainer, $wiki]) => {
  if ($explainer !== "") {
    return $wiki.machines[$explainer]
  }

  return ""
})