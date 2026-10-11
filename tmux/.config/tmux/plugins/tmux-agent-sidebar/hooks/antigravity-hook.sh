#!/usr/bin/env bash
# Antigravity CLI hook -> tmux-agent-sidebar state.
# Wire into ~/.gemini/config/hooks.json (agy 1.1.x) or ~/.gemini/antigravity-cli/hooks.json
# Events: SessionStart, PreInvocation, PreToolUse, PostToolUse, PostInvocation, Stop
# See: https://antigravity.google/docs/hooks/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_SCRIPT="$SCRIPT_DIR/../scripts/agent-state.sh"
export HARNESS=antigravity

event="${1:-}"
payload="$(cat 2>/dev/null || true)"

# Extract working directory from payload (cwd or conversationId)
cwd="$(printf '%s' "$payload" | sed -n 's/.*"cwd"[: ]*"\([^"]*\)".*/\1/p' | head -1)"
if [ -z "$cwd" ]; then
    cwd="$(printf '%s' "$payload" | sed -n 's/.*"conversationId"[: ]*"\([^"]*\)".*/\1/p' | head -1)" || true
fi
summary="$(basename "${cwd:-$(pwd)}")"

case "$event" in
    SessionStart|PreInvocation|PreToolUse|PostToolUse|PostInvocation)
        "$STATE_SCRIPT" set working "$summary"
        ;;
    Stop)
        "$STATE_SCRIPT" set done "$summary"
        ;;
    *)
        exit 0
        ;;
esac