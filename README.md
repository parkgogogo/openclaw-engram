# OpenClaw Engram

`openclaw-engram` is a minimal OpenClaw plugin that exposes fixed slash commands for nudging memory updates.

It does not analyze conversations, call an LLM, or write memory files by itself.
Instead, it gives you five explicit commands that return plain-text prompts for OpenClaw to act on:

- `/engram-user`
- `/engram-identity`
- `/engram-soul`
- `/engram-memory`
- `/engram-tools`

## Positioning

OpenClaw Engram is for users who want a lighter memory workflow:

- no automatic reflection pipeline
- no background hooks
- no write guardians or consolidation jobs
- no hidden decision logic

You decide when memory maintenance should happen by running a command.

## Install

```bash
openclaw plugins install @parkgogogo/openclaw-engram
```

Add the plugin to your OpenClaw config:

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

No additional configuration is required.

## Commands

### `/engram-user`

Returns a prompt asking OpenClaw to update `USER.md` with stable user preferences, collaboration style, and durable personal context.

### `/engram-identity`

Returns a prompt asking OpenClaw to update `IDENTITY.md` with explicit identity descriptors.

### `/engram-soul`

Returns a prompt asking OpenClaw to update `SOUL.md` with assistant principles, boundaries, and continuity rules.

### `/engram-memory`

Returns a prompt asking OpenClaw to update `MEMORY.md` with long-lived shared context and lasting conclusions.

### `/engram-tools`

Returns a prompt asking OpenClaw to update `TOOLS.md` with tool mappings, aliases, endpoints, and environment-specific details.

## Behavior

Each command returns fixed plain text.

- No variables are interpolated
- No current conversation is analyzed
- The command means the target file must be updated
- Additive information should be appended to the target file
- Conflicting information should go through OpenClaw's confirmation flow before replacement
- No file is written directly by the plugin

## Development

```bash
npm install
npm test
npm run e2e:openclaw-plugin
```

`npm test` verifies the command registration contract, package metadata, and the presence of the local e2e entrypoint.

`npm run e2e:openclaw-plugin` runs the real OpenClaw gateway flow locally in an isolated temporary profile, installs the packed tarball, and verifies slash command responses through the gateway.
