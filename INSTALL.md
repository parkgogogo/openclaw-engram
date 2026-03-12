# Install OpenClaw Engram

## 1. Install the package

```bash
openclaw plugins install @parkgogogo/openclaw-engram
```

## 2. Add the plugin entry

```json
{
  "plugins": {
    "entries": {
      "openclaw-engram": {
        "enabled": true,
        "config": {}
      }
    }
  }
}
```

## 3. Restart OpenClaw

Restart the OpenClaw gateway or reload plugins according to your local setup.

## 4. Use one of the slash commands

- `/engram-user`
- `/engram-identity`
- `/engram-soul`
- `/engram-memory`
- `/engram-tools`

The plugin ships these as bundled skill commands, so they drive the OpenClaw agent instead of returning static plugin output.
Each command represents an explicit write intent: additive information should be appended, and conflicting facts should be routed through OpenClaw's existing confirmation flow before replacement.

## 5. Run the local e2e check

```bash
npm run e2e:openclaw-plugin
```

This boots an isolated OpenClaw profile, installs the packed plugin, triggers `/engram-user` and `/engram-tools`, and verifies that `USER.md` and `TOOLS.md` are actually updated.

If you want to override the API key from `.env` for this check, export `OPENCLAW_E2E_API_KEY` first.
