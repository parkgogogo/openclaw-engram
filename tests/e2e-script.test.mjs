import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import path from "node:path";

test("package exposes the local OpenClaw e2e script", async () => {
  const packageJsonPath = path.join(process.cwd(), "package.json");
  const packageJson = JSON.parse(await fs.readFile(packageJsonPath, "utf8"));

  assert.equal(
    packageJson.scripts["e2e:openclaw-plugin"],
    "bash scripts/e2e-openclaw-plugin.sh"
  );
});

test("local OpenClaw e2e script exists in scripts/", async () => {
  const scriptPath = path.join(process.cwd(), "scripts", "e2e-openclaw-plugin.sh");
  const stats = await fs.stat(scriptPath);

  assert.equal(stats.isFile(), true);
});
