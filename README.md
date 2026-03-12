# OpenClaw Engram

## OpenClaw memory, made simple.

`openclaw-engram` is the simple way to update OpenClaw memory on purpose.

No automatic reflection pipeline.  
No background analysis.  
No hidden write decisions.  
No memory system trying to be smarter than you.

Install one plugin. Get five bundled skill commands. OpenClaw updates the memory file you meant.

## Install

```bash
openclaw plugins install @parkgogogo/openclaw-engram
```

Add this to your OpenClaw config:

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

No extra configuration.

## Why Engram

Reflection was powerful.
Engram is simpler.

It turns memory writing into an explicit action:

- one command
- one target file
- one clear write intent

You decide when memory should change.

## How It Works

The plugin ships five bundled `user-invocable` skills, each exposed as a slash command:

- `/engram-user`
- `/engram-identity`
- `/engram-soul`
- `/engram-memory`
- `/engram-tools`

When you run one, OpenClaw routes the command into the agent and updates that specific file.

That is the whole product.

## Writing Rules

Engram keeps the rules simple:

- only update the target file
- additive information should be appended
- conflicting facts should go through OpenClaw's confirmation flow before replacement
- the command means the file should be updated, not skipped

## The Five Commands

### `/engram-user`

Update `USER.md`.

### `/engram-identity`

Update `IDENTITY.md`.

### `/engram-soul`

Update `SOUL.md`.

### `/engram-memory`

Update `MEMORY.md`.

### `/engram-tools`

Update `TOOLS.md`.

## Development

```bash
npm install
npm test
npm run e2e:openclaw-plugin
```

`npm test` verifies the bundled-skill contract and package metadata.

`npm run e2e:openclaw-plugin` runs the real local OpenClaw gateway flow with an isolated profile and verifies actual writes to `USER.md` and `TOOLS.md`.

If you need to override the `.env` key for e2e, export `OPENCLAW_E2E_API_KEY` before running the script.
