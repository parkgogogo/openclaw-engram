---
name: engram-memory
description: Update MEMORY.md from the current conversation. Use when the user explicitly invokes /engram-memory to write durable shared context, lasting conclusions, or long-lived background facts.
user-invocable: true
metadata:
  { "openclaw": { "requires": { "config": ["plugins.entries.openclaw-engram.enabled"] } } }
---

# Engram Memory

This command means the user explicitly wants `MEMORY.md` updated now.

Workflow:

1. Inspect the latest conversation context and any command arguments.
2. Extract only durable shared context, lasting conclusions, or long-lived background facts.
3. Read `MEMORY.md` if it exists. Create it if it does not.
4. If the new information is additive, append it to the end of `MEMORY.md`.
5. If the new information conflicts with an existing fact in `MEMORY.md`, do not silently overwrite it. Identify the conflict, propose replacing the old fact with the new fact, and follow OpenClaw's existing confirmation or suggestion flow before making that replacement.
6. Do not modify any other memory file.

Keep the update concise and durable.
