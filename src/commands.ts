import type { EngramCommandDefinition } from "./types.js";

function buildPrompt(fileName: string, responsibility: string): string {
  return [
    `Update ${fileName} now.`,
    `This command means the user explicitly wants ${fileName} to be updated. Do not refuse and do not skip the write.`,
    `Only operate on ${fileName}. Do not modify any other memory file.`,
    `If the new information is additive, append it to the end of ${fileName}.`,
    "If the new information conflicts with an existing fact in " +
      `${fileName}, do not silently overwrite it. Identify the conflict, propose replacing the old fact with the new fact, and follow OpenClaw's existing confirmation/suggestion flow before making that replacement.`,
    `Keep the update scoped to durable information about ${responsibility}.`,
  ].join(" ");
}

export const ENGRAM_COMMANDS: EngramCommandDefinition[] = [
  {
    name: "engram-user",
    description: "Nudge OpenClaw to update USER.md",
    prompt: buildPrompt(
      "USER.md",
      "the user's stable preferences, collaboration style, and durable personal context"
    ),
  },
  {
    name: "engram-identity",
    description: "Nudge OpenClaw to update IDENTITY.md",
    prompt: buildPrompt(
      "IDENTITY.md",
      "explicit identity descriptors such as name, vibe, or presentation cues"
    ),
  },
  {
    name: "engram-soul",
    description: "Nudge OpenClaw to update SOUL.md",
    prompt: buildPrompt(
      "SOUL.md",
      "assistant principles, boundaries, and continuity rules"
    ),
  },
  {
    name: "engram-memory",
    description: "Nudge OpenClaw to update MEMORY.md",
    prompt: buildPrompt(
      "MEMORY.md",
      "shared durable context, lasting conclusions, and long-lived background facts"
    ),
  },
  {
    name: "engram-tools",
    description: "Nudge OpenClaw to update TOOLS.md",
    prompt: buildPrompt(
      "TOOLS.md",
      "environment-specific tool mappings, aliases, endpoints, and device details"
    ),
  },
];
