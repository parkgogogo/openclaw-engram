---
name: engram-user
description: Update USER.md from the current conversation. Use when the user explicitly invokes /engram-user to write stable user preferences, collaboration style, or durable personal context.
user-invocable: true
metadata:
  { "openclaw": { "requires": { "config": ["plugins.entries.openclaw-engram.enabled"] } } }
---

# Engram User

This command means the user explicitly wants `USER.md` updated now.

Workflow:

1. Inspect the latest conversation context and any command arguments.
2. Extract only durable user preferences, collaboration style, or lasting personal context.
3. Read `USER.md` if it exists. Create it if it does not.
4. If the new information is additive, append it to the end of `USER.md`.
5. If the new information conflicts with an existing fact in `USER.md`, do not silently overwrite it. Identify the conflict, propose replacing the old fact with the new fact, and follow OpenClaw's existing confirmation or suggestion flow before making that replacement.
6. Do not modify any other memory file.

Keep the update concise and durable.
