---
name: engram-tools
description: Update TOOLS.md from the current conversation. Use when the user explicitly invokes /engram-tools to write durable tool mappings, aliases, endpoints, or environment-specific details.
user-invocable: true
metadata:
  { "openclaw": { "requires": { "config": ["plugins.entries.openclaw-engram.enabled"] } } }
---

# Engram Tools

This command means the user explicitly wants `TOOLS.md` updated now.

Workflow:

1. Inspect the latest conversation context and any command arguments.
2. Extract only durable tool mappings, aliases, endpoints, or environment-specific details.
3. Read `TOOLS.md` if it exists. Create it if it does not.
4. If the new information is additive, append it to the end of `TOOLS.md`.
5. If the new information conflicts with an existing fact in `TOOLS.md`, do not silently overwrite it. Identify the conflict, propose replacing the old fact with the new fact, and follow OpenClaw's existing confirmation or suggestion flow before making that replacement.
6. Do not modify any other memory file.

Keep the update concise and durable.
