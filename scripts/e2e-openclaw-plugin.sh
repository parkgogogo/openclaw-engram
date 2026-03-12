#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_NAME="${OPENCLAW_TEST_PROFILE:-engram-package-test}"
GATEWAY_PORT="${OPENCLAW_TEST_GATEWAY_PORT:-18891}"
KEEP_E2E_ARTIFACTS="${KEEP_E2E_ARTIFACTS:-0}"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/openclaw-engram-e2e.XXXXXX")"
ARTIFACTS_DIR="$TMP_ROOT/artifacts"
WORKSPACE_DIR="$TMP_ROOT/workspace"
PROFILE_DIR="$TMP_ROOT/home/.openclaw-$PROFILE_NAME"
PROFILE_CONFIG="$PROFILE_DIR/openclaw.json"
HEALTH_JSON="$ARTIFACTS_DIR/health.json"
USER_JSON="$ARTIFACTS_DIR/user-command.json"
TOOLS_JSON="$ARTIFACTS_DIR/tools-command.json"
HISTORY_JSON="$ARTIFACTS_DIR/chat-history.json"
USER_ERR="$ARTIFACTS_DIR/user-command.stderr.log"
TOOLS_ERR="$ARTIFACTS_DIR/tools-command.stderr.log"
HISTORY_ERR="$ARTIFACTS_DIR/chat-history.stderr.log"
GATEWAY_LOG="$ARTIFACTS_DIR/gateway.log"
TARBALL_PATH=""
GATEWAY_PID=""
HOST_HOME="${HOME}"

export HOME="$TMP_ROOT/home"
export XDG_CONFIG_HOME="$TMP_ROOT/xdg-config"
export XDG_CACHE_HOME="$TMP_ROOT/xdg-cache"
export XDG_DATA_HOME="$TMP_ROOT/xdg-data"
export npm_config_cache="$TMP_ROOT/npm-cache"

mkdir -p \
  "$HOME" \
  "$XDG_CONFIG_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_DATA_HOME" \
  "$npm_config_cache" \
  "$ARTIFACTS_DIR" \
  "$WORKSPACE_DIR"

print_artifact_location() {
  echo "[e2e] artifacts: $TMP_ROOT"
}

cleanup() {
  local rc="${1:-0}"

  if [[ -n "$GATEWAY_PID" ]] && kill -0 "$GATEWAY_PID" 2>/dev/null; then
    pkill -TERM -P "$GATEWAY_PID" 2>/dev/null || true
    kill "$GATEWAY_PID" 2>/dev/null || true
    wait "$GATEWAY_PID" 2>/dev/null || true
  fi

  if [[ -n "$TARBALL_PATH" && -f "$TARBALL_PATH" ]]; then
    rm -f "$TARBALL_PATH"
  fi

  if [[ "$KEEP_E2E_ARTIFACTS" == "1" || "$rc" != "0" ]]; then
    print_artifact_location
    return
  fi

  rm -rf "$TMP_ROOT"
}
trap 'rc=$?; trap - EXIT; cleanup "$rc"; exit "$rc"' EXIT

fail() {
  local message="$1"
  echo "[e2e] $message" >&2

  if [[ -f "$GATEWAY_LOG" ]]; then
    echo "--- gateway log ---" >&2
    cat "$GATEWAY_LOG" >&2 || true
  fi

  if [[ -f "$USER_ERR" ]]; then
    echo "--- /engram-user stderr ---" >&2
    cat "$USER_ERR" >&2 || true
  fi

  if [[ -f "$TOOLS_ERR" ]]; then
    echo "--- /engram-tools stderr ---" >&2
    cat "$TOOLS_ERR" >&2 || true
  fi

  if [[ -f "$USER_JSON" ]]; then
    echo "--- /engram-user response ---" >&2
    cat "$USER_JSON" >&2 || true
  fi

  if [[ -f "$TOOLS_JSON" ]]; then
    echo "--- /engram-tools response ---" >&2
    cat "$TOOLS_JSON" >&2 || true
  fi

  if [[ -f "$HISTORY_ERR" ]]; then
    echo "--- chat.history stderr ---" >&2
    cat "$HISTORY_ERR" >&2 || true
  fi

  if [[ -f "$HISTORY_JSON" ]]; then
    echo "--- chat.history response ---" >&2
    cat "$HISTORY_JSON" >&2 || true
  fi

  exit 1
}

assert_contains() {
  local file_path="$1"
  local needle="$2"

  if ! grep -Fq "$needle" "$file_path"; then
    fail "expected '$needle' in $file_path"
  fi
}

NVM_DIR="${NVM_DIR:-$HOST_HOME/.nvm}"
NODE_BIN=""
NPM_BIN=""
OPENCLAW_BIN=""
OPENCLAW_MJS=""

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # shellcheck source=/dev/null
  source "$NVM_DIR/nvm.sh"
  NODE_BIN="$(nvm which 22 2>/dev/null || true)"
fi

if [[ -z "$NODE_BIN" || ! -x "$NODE_BIN" ]]; then
  NODE_BIN="$(command -v node || true)"
fi

if [[ -z "$NODE_BIN" || ! -x "$NODE_BIN" ]]; then
  fail "node is required in PATH"
fi

NPM_BIN="$(cd "$(dirname "$NODE_BIN")" && pwd)/npm"
if [[ ! -x "$NPM_BIN" ]]; then
  NPM_BIN="$(command -v npm || true)"
fi

if [[ -z "$NPM_BIN" || ! -x "$NPM_BIN" ]]; then
  fail "npm is required in PATH"
fi

OPENCLAW_BIN="$(cd "$(dirname "$NODE_BIN")" && pwd)/openclaw"
if [[ ! -x "$OPENCLAW_BIN" ]]; then
  OPENCLAW_BIN="$(command -v openclaw || true)"
fi

if [[ -z "$OPENCLAW_BIN" || ! -x "$OPENCLAW_BIN" ]]; then
  fail "openclaw CLI is required in PATH"
fi

OPENCLAW_MJS="$(python3 - <<'EOF' "$OPENCLAW_BIN"
import os
import sys

print(os.path.realpath(sys.argv[1]))
EOF
)"

if [[ ! -f "$OPENCLAW_MJS" ]]; then
  fail "openclaw entrypoint could not be resolved"
fi

run_openclaw() {
  "$NODE_BIN" "$OPENCLAW_MJS" --profile "$PROFILE_NAME" "$@"
}

echo "[e2e] bootstrapping isolated profile in $TMP_ROOT"
run_openclaw onboard \
  --non-interactive \
  --accept-risk \
  --mode local \
  --flow quickstart \
  --workspace "$WORKSPACE_DIR" \
  --gateway-bind loopback \
  --gateway-port "$GATEWAY_PORT" \
  --skip-channels \
  --skip-skills \
  --skip-ui \
  --skip-health \
  --skip-daemon \
  >/dev/null

if [[ ! -f "$PROFILE_CONFIG" ]]; then
  fail "OpenClaw onboarding did not create $PROFILE_CONFIG"
fi

echo "[e2e] packing plugin tarball"
TARBALL_NAME="$(cd "$ROOT_DIR" && "$NPM_BIN" pack | tail -n 1)"
TARBALL_PATH="$ROOT_DIR/$TARBALL_NAME"

echo "[e2e] installing tarball into profile $PROFILE_NAME"
run_openclaw plugins install "$TARBALL_PATH" >/dev/null

echo "[e2e] enabling plugin in profile config"
"$NODE_BIN" - "$PROFILE_CONFIG" <<'EOF'
const fs = require("node:fs");

const [configPath] = process.argv.slice(2);
const config = JSON.parse(fs.readFileSync(configPath, "utf8"));

config.plugins = config.plugins ?? {};
if (Array.isArray(config.plugins.allow)) {
  if (!config.plugins.allow.includes("openclaw-engram")) {
    config.plugins.allow.push("openclaw-engram");
  }
} else {
  config.plugins.allow = ["openclaw-engram"];
}

config.plugins.entries = config.plugins.entries ?? {};
config.plugins.entries["openclaw-engram"] = {
  ...(config.plugins.entries["openclaw-engram"] ?? {}),
  enabled: true,
  config: {},
};

fs.writeFileSync(configPath, `${JSON.stringify(config, null, 2)}\n`);
EOF

run_openclaw config validate --json >"$ARTIFACTS_DIR/config-validate.json"

if lsof -nP -iTCP:"$GATEWAY_PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  fail "gateway port $GATEWAY_PORT is already in use"
fi

echo "[e2e] starting gateway on port $GATEWAY_PORT"
run_openclaw gateway run --verbose >"$GATEWAY_LOG" 2>&1 &
GATEWAY_PID=$!

for _ in 1 2 3 4 5 6 7 8 9 10; do
  if [[ -n "$GATEWAY_PID" ]] && ! kill -0 "$GATEWAY_PID" 2>/dev/null; then
    fail "gateway exited before becoming healthy"
  fi

  if curl --silent --show-error --fail --max-time 2 "http://127.0.0.1:$GATEWAY_PORT/health" >"$HEALTH_JSON" 2>/dev/null; then
    break
  fi

  sleep 1
done

assert_contains "$HEALTH_JSON" '"ok":true'

USER_IDEMPOTENCY_KEY="e2e-user-$(date +%s)-$$"
USER_PARAMS="$(printf '{"sessionKey":"main","message":"/engram-user","idempotencyKey":"%s","timeoutMs":120000}' "$USER_IDEMPOTENCY_KEY")"

TOOLS_IDEMPOTENCY_KEY="e2e-tools-$(date +%s)-$$"
TOOLS_PARAMS="$(printf '{"sessionKey":"main","message":"/engram-tools","idempotencyKey":"%s","timeoutMs":120000}' "$TOOLS_IDEMPOTENCY_KEY")"

echo "[e2e] sending /engram-user"
if ! run_openclaw gateway call chat.send --json --expect-final --timeout 30000 --params "$USER_PARAMS" >"$USER_JSON" 2>"$USER_ERR"; then
  fail "/engram-user command failed"
fi

echo "[e2e] sending /engram-tools"
if ! run_openclaw gateway call chat.send --json --expect-final --timeout 30000 --params "$TOOLS_PARAMS" >"$TOOLS_JSON" 2>"$TOOLS_ERR"; then
  fail "/engram-tools command failed"
fi

sleep 2

echo "[e2e] fetching chat history"
if ! run_openclaw gateway call chat.history --json --timeout 30000 --params '{"sessionKey":"main","limit":20}' >"$HISTORY_JSON" 2>"$HISTORY_ERR"; then
  fail "chat.history failed"
fi

assert_contains "$HISTORY_JSON" "Update USER.md"
assert_contains "$HISTORY_JSON" "Update TOOLS.md"

echo "[e2e] gateway health ok"
cat "$HEALTH_JSON"
echo "[e2e] success"
