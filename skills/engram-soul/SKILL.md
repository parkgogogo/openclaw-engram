---
name: engram-soul
description: Update SOUL.md from the current conversation. Use when the user explicitly invokes /engram-soul to write assistant principles, boundaries, or continuity rules.
user-invocable: true
metadata:
  { "openclaw": { "requires": { "config": ["plugins.entries.openclaw-engram.enabled"] } } }
---

# Engram Soul

This command means the user explicitly wants `SOUL.md` updated now.

Workflow:

1. Inspect the latest conversation context and any command arguments.
2. Extract only durable assistant principles, boundaries, or continuity rules.
3. Read `SOUL.md` if it exists. Create it if it does not.
4. If the new information is additive, append it to the end of `SOUL.md`.
5. If the new information conflicts with an existing fact in `SOUL.md`, do not silently overwrite it. Identify the conflict, propose replacing the old fact with the new fact, and follow OpenClaw's existing confirmation or suggestion flow before making that replacement.
6. Do not modify any other memory file.

Keep the update concise and durable.
