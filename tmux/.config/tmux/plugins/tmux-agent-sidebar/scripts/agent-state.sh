#!/usr/bin/env bash
# tmux-agent-sidebar: agent state CLI
# Usage:
#   agent-state.sh set <status> [summary]   current pane (or $TMUX_PANE)
#   agent-state.sh set <pane-id> <status> [summary]
#   agent-state.sh get [pane-id]
#   agent-state.sh clear [pane-id]
# States: working | waiting | done | idle

set -euo pipefail

STATE_DIR="${TMUX_AGENT_SIDEBAR_DIR:-$HOME/.cache/tmux-agent-sidebar}"

usage() {
    echo "usage: agent-state.sh set [pane-id] <working|waiting|done|idle> [summary]" >&2
    echo "       agent-state.sh get [pane-id]" >&2
    echo "       agent-state.sh clear [pane-id]" >&2
    exit 2
}

valid_state() {
    case "$1" in
        working|waiting|done|idle) return 0 ;;
        *) return 1 ;;
    esac
}

cmd="${1:-}"
[ -n "$cmd" ] || usage
shift

pane_id="${TMUX_PANE:-}"
[ -n "$pane_id" ] || pane_id="$(tmux display-message -p '#{pane_id}' 2>/dev/null || true)"
[ -n "$pane_id" ] || { echo "agent-state.sh: no pane id available (run inside tmux)" >&2; exit 1; }

case "$cmd" in
    set)
        if valid_state "${1:-}" && [ $# -le 2 ]; then
            status="$1"; shift
            summary="${1:-}"
        elif [ $# -ge 2 ] && valid_state "$2"; then
            pane_id="$1"; shift
            status="$1"; shift
            summary="${1:-}"
        else
            usage
        fi
        if [ -z "$summary" ] && [ -f "$STATE_DIR/$pane_id.json" ]; then
            summary="$(sed -n 's/.*"summary"[: ]*"\([^"]*\)".*/\1/p' "$STATE_DIR/$pane_id.json")"
        fi
        if [ -z "${HARNESS:-}" ] && [ -f "$STATE_DIR/$pane_id.json" ]; then
            HARNESS="$(sed -n 's/.*"harness"[: ]*"\([^"]*\)".*/\1/p' "$STATE_DIR/$pane_id.json")"
        fi
        mkdir -p "$STATE_DIR"
        now="$(date +%s)"
        window="$(tmux display-message -p -t "$pane_id" '#{window_index}:#{window_name}' 2>/dev/null || true)"
        summary="${summary//\"/\\\"}"
        harness="${HARNESS:-}"; harness="${harness//\"/}"
        fmt='{"pane":"%s","status":"%s","summary":"%s","window":"%s",'
        fmt+=' "updated":"%s","detected":false,"harness":"%s"}\n'
        printf "$fmt" \
            "$pane_id" "$status" "$summary" "$window" "$now" "$harness" \
            > "$STATE_DIR/$pane_id.json"
        ;;
    get)
        [ $# -eq 1 ] && pane_id="$1"
        if [ -f "$STATE_DIR/$pane_id.json" ]; then
            cat "$STATE_DIR/$pane_id.json"
        fi
        ;;
    clear)
        [ $# -eq 1 ] && pane_id="$1"
        rm -f "$STATE_DIR/$pane_id.json"
        ;;
    *)
        usage
        ;;
esac