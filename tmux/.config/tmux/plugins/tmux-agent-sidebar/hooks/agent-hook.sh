# Any-agent hook -> tmux-agent-sidebar state.
# Wire into your agent config to emit these events:
#   UserPromptSubmit, PreToolUse -> working
#   Notification                -> waiting
#   Stop                        -> done

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

event="${1:-}"
payload="$(cat 2>/dev/null || true)"

# harness can be passed explicitly (e.g. from a wrapper), otherwise detect from parent proc
harness="${HARNESS:-}"
if [ -z "$harness" ]; then
    ppid="$(ps -o ppid= -p $$ 2>/dev/null || true)"
    harness="$(ps -o args= -p "$ppid" 2>/dev/null | grep -o 'bulle\|nacelle\|claude\|codex' | head -1)"
fi
export HARNESS="${harness:-agent}"

cwd="$(printf '%s' "$payload" | sed -n 's/.*"cwd"[: ]*"\([^"]*\)".*/\1/p' | head -1)"
summary="$(basename "${cwd:-$(pwd)}")"

case "$event" in
    UserPromptSubmit|PreToolUse)
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
