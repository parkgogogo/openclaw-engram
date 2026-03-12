export interface PluginLogger {
  debug(message: string, ...args: unknown[]): void;
  info(message: string, ...args: unknown[]): void;
  warn(message: string, ...args: unknown[]): void;
  error(message: string, ...args: unknown[]): void;
}

export interface CommandResponse {
  text: string;
}

export interface PluginCommand {
  name: string;
  description: string;
  handler: (args?: string) => CommandResponse | Promise<CommandResponse>;
}

export interface PluginAPI {
  logger: PluginLogger;
  registerCommand?: (command: PluginCommand) => void;
}

export interface EngramCommandDefinition {
  name: string;
  description: string;
  prompt: string;
}
