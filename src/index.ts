import { ENGRAM_COMMANDS } from "./commands.js";
import type { CommandResponse, EngramCommandDefinition, PluginAPI } from "./types.js";

function createCommandResponse(command: EngramCommandDefinition): CommandResponse {
  return {
    text: command.prompt,
  };
}

export default function activate(api: PluginAPI): void {
  if (typeof api.registerCommand !== "function") {
    api.logger.warn(
      "[Engram] registerCommand is unavailable; slash commands were not registered."
    );
    return;
  }

  for (const command of ENGRAM_COMMANDS) {
    api.registerCommand({
      name: command.name,
      description: command.description,
      handler: async () => createCommandResponse(command),
    });
  }

  api.logger.info(
    `[Engram] Registered ${ENGRAM_COMMANDS.length} memory prompt commands.`
  );
}
