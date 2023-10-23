import type { SoundLibrary } from "../types";

import { ui } from "./ui";
import { tcm } from "./tcm";
import { misc } from "./misc";
import { scream } from "./scream";
import { tekken } from "./tekken";

export const soundLibrary: SoundLibrary = {
  ui,
  misc,
  scream,
  tekken,
  tcm
};
