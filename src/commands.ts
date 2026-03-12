import type { EngramCommandDefinition } from "./types.js";

function buildPrompt(fileName: string, responsibility: string): string {
  return [
    `Update ${fileName} with durable information about ${responsibility}.`,
    `Write only if there is stable, worthwhile information that belongs in ${fileName}.`,
    "If there is no durable update to make, do not write anything.",
  ].join(" ");
}

export const ENGRAM_COMMANDS: EngramCommandDefinition[] = [
  {
    name: "user",
    description: "Nudge OpenClaw to update USER.md",
    prompt: buildPrompt(
      "USER.md",
      "the user's stable preferences, collaboration style, and durable personal context"
    ),
  },
  {
    name: "identity",
    description: "Nudge OpenClaw to update IDENTITY.md",
    prompt: buildPrompt(
      "IDENTITY.md",
      "explicit identity descriptors such as name, vibe, or presentation cues"
    ),
  },
  {
    name: "soul",
    description: "Nudge OpenClaw to update SOUL.md",
    prompt: buildPrompt(
      "SOUL.md",
      "assistant principles, boundaries, and continuity rules"
    ),
  },
  {
    name: "memory",
    description: "Nudge OpenClaw to update MEMORY.md",
    prompt: buildPrompt(
      "MEMORY.md",
      "shared durable context, lasting conclusions, and long-lived background facts"
    ),
  },
  {
    name: "tools",
    description: "Nudge OpenClaw to update TOOLS.md",
    prompt: buildPrompt(
      "TOOLS.md",
      "environment-specific tool mappings, aliases, endpoints, and device details"
    ),
  },
];
