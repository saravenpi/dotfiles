#!/usr/bin/env bash
# Codex CLI hook -> tmux-agent-sidebar state.
# Wire into ~/.codex/hooks.json the same way as the Claude hook, events:
#   SessionStart, UserPromptSubmit, PreToolUse, Stop

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export HARNESS=codex

event="${1:-}"
payload="$(cat 2>/dev/null || true)"

cwd="$(printf '%s' "$payload" | sed -n 's/.*"cwd"[: ]*"\([^"]*\)".*/\1/p' | head -1)"
summary="$(basename "${cwd:-$(pwd)}")"

case "$event" in
    SessionStart|UserPromptSubmit|PreToolUse)
        "$SCRIPT_DIR/../scripts/agent-state.sh" set working "$summary"
        ;;
    Notification)
        "$SCRIPT_DIR/../scripts/agent-state.sh" set waiting "$summary"
        ;;
    Stop)
        "$SCRIPT_DIR/../scripts/agent-state.sh" set done "$summary"
        ;;
    *)
        exit 0
        ;;
esac