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

test("activate does not register direct plugin commands or message hooks", async () => {
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

  assert.deepEqual(commands.map((command) => command.name), []);
  assert.equal(observedHooks.length, 0);
  assert.equal(registeredHooks.length, 0);
});

test("engram metadata publishes bundled skills from the plugin package", async () => {
  const packageJsonPath = path.join(process.cwd(), "package.json");
  const pluginManifestPath = path.join(process.cwd(), "openclaw.plugin.json");

  const packageJson = JSON.parse(await fs.readFile(packageJsonPath, "utf8"));
  const pluginManifest = JSON.parse(await fs.readFile(pluginManifestPath, "utf8"));

  assert.equal(packageJson.name, "@parkgogogo/openclaw-engram");
  assert.match(packageJson.description, /plugin/i);
  assert.ok(Array.isArray(packageJson.files));
  assert.ok(packageJson.files.includes("skills/"));
  assert.equal(pluginManifest.id, "openclaw-engram");
});
