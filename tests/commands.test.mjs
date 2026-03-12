import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";
import { pathToFileURL } from "node:url";

function createPluginLogger() {
  return {
    debug() {},
    info() {},
    warn() {},
    error() {},
  };
}

async function loadActivate(suffix) {
  const indexUrl = pathToFileURL(path.join(process.cwd(), "dist/index.js")).href;
  const mod = await import(`${indexUrl}?t=${suffix}`);
  return mod.default;
}

test("activate registers exactly five engram commands and no message hooks", async () => {
  const activate = await loadActivate(`engram-${Date.now()}`);

  const commands = [];
  const observedHooks = [];
  const registeredHooks = [];

  activate({
    logger: createPluginLogger(),
    on(event, handler) {
      observedHooks.push({ event, handler });
    },
    registerHook(event, handler) {
      registeredHooks.push({ event, handler });
    },
    registerCommand(command) {
      commands.push(command);
    },
  });

  assert.deepEqual(commands.map((command) => command.name), [
    "engram-user",
    "engram-identity",
    "engram-soul",
    "engram-memory",
    "engram-tools",
  ]);
  assert.equal(observedHooks.length, 0);
  assert.equal(registeredHooks.length, 0);

  for (const command of commands) {
    assert.equal(typeof command.description, "string");
    assert.notEqual(command.description.trim(), "");

    const result = await command.handler();
    assert.equal(typeof result.text, "string");
    assert.notEqual(result.text.trim(), "");
    assert.match(result.text, /Update .* now\./);
    assert.match(result.text, /Do not refuse and do not skip the write\./);
    assert.match(result.text, /Only operate on .* Do not modify any other memory file\./);
    assert.match(result.text, /append it to the end of/);
    assert.match(
      result.text,
      /do not silently overwrite it\. Identify the conflict, propose replacing the old fact with the new fact, and follow OpenClaw's existing confirmation\/suggestion flow before making that replacement\./
    );
  }
});

test("engram metadata is rebranded around command-only memory nudges", async () => {
  const packageJsonPath = path.join(process.cwd(), "package.json");
  const pluginManifestPath = path.join(process.cwd(), "openclaw.plugin.json");

  const packageJson = JSON.parse(await fs.readFile(packageJsonPath, "utf8"));
  const pluginManifest = JSON.parse(await fs.readFile(pluginManifestPath, "utf8"));

  assert.equal(packageJson.name, "@parkgogogo/openclaw-engram");
  assert.match(packageJson.description, /command/i);
  assert.equal(pluginManifest.id, "openclaw-engram");
});
