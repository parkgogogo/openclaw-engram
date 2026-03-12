import type { PluginAPI } from "./types.js";

export default function activate(api: PluginAPI): void {
  api.logger.info("[Engram] Plugin activated. Bundled skills will provide the engram commands.");
}
