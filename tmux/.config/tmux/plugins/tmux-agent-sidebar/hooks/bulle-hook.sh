#!/usr/bin/env bash
# Bulle hook -> tmux-agent-sidebar state.
# Wire into your bulle harness configuration:
#   ~/.bulle/ with events UserPromptSubmit, PreToolUse, Notification, Stop

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_SCRIPT="$SCRIPT_DIR/../scripts/agent-state.sh"
export HARNESS=bulle

event="${1:-}"
payload="$(cat 2>/dev/null || true)"

cwd="$(printf '%s' "$payload" | sed -n 's/.*"cwd"[: ]*"\([^"]*\)".*/\1/p' | head -1)"
summary="$(basename "${cwd:-$(pwd)}")"

case "$event" in
    UserPromptSubmit|PreToolUse)
        "$STATE_SCRIPT" set working "$summary"
        ;;
    Notification)
        "$STATE_SCRIPT" set waiting "$summary"
        ;;
    Stop)
        "$STATE_SCRIPT" set done "$summary"
        ;;
    *)
        exit 0
        ;;
esac