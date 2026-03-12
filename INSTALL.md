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

Each command returns a fixed prompt that asks OpenClaw to update one specific memory file only when there is durable information worth recording.
Each command now represents an explicit write intent: additive information should be appended, and conflicting facts should be routed through OpenClaw's existing confirmation flow before replacement.
