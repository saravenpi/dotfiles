#!/usr/bin/env bash
# Sidebar renderer: one line per agent pane, one single write per frame.
#
# Frame discipline:
# - the frame is built as visible text + pad per line, then one write; the
#   cursor moves with \r\n between lines, never inside a padded string
# - history-limit 1 + no scrollback: the pane is a canvas, not a terminal

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="${TMUX_AGENT_SIDEBAR_DIR:-$HOME/.cache/tmux-agent-sidebar}"
INTERVAL="${TMUX_AGENT_SIDEBAR_INTERVAL:-1}"

SPINNER=('▖' '▘' '▝' '▗')
tick=0

dims() {
    tmux display-message -p -t "${TMUX_PANE:-}" '#{pane_width}|#{pane_height}' 2>/dev/null || echo "28|40"
}

color_for() {
    case "$1" in
        working) printf '\033[32m' ;;
        waiting) printf '\033[33m' ;;
        done)    printf '\033[36m' ;;
        idle)    printf '\033[90m' ;;
        *)       printf '\033[0m'  ;;
    esac
}

sym_for_static() {
    case "$1" in
        waiting) printf '?' ;;
        done)    printf '✓' ;;
        *)       printf '·' ;;
    esac
}

vlen() {
    printf '%s' "$1" | sed 's/\x1b\[[0-9;]*m//g' | wc -m
}

build_frame() {
    local width height
    IFS='|' read -r width height <<< "$(dims)"
    local usable=$(( width - 1 ))

    frame=""
    # one line = text, then pad of spaces to fill the row, then \r\n
    add_line() {
        local pad=$(( usable - $(vlen "$1") ))
        [ "$pad" -lt 0 ] && pad=0
        frame+="$1"
        while [ "$pad" -gt 0 ]; do frame+=" "; pad=$(( pad - 1 )); done
        frame+=$'\r\n'
    }

    add_line ""
    add_line "\033[1m agents\033[0m"
    add_line ""

    local found=0
    local lines=3
    for f in "$STATE_DIR"/*.json; do
        [ -f "$f" ] || continue
        found=1
        lines=$(( lines + 1 ))
        [ "$lines" -gt "$height" ] && break

        pane="$(sed -n 's/.*"pane"[: ]*"\([^"]*\)".*/\1/p' "$f")"
        status="$(sed -n 's/.*"status"[: ]*"\([^"]*\)".*/\1/p' "$f")"
        summary="$(sed -n 's/.*"summary"[: ]*"\([^"]*\)".*/\1/p' "$f")"
        window="$(sed -n 's/.*"window"[: ]*"\([^"]*\)".*/\1/p' "$f")"
        if [ -z "$window" ]; then
            window="$(tmux display-message -p -t "$pane" \
                '#{window_index}:#{window_name}' 2>/dev/null || echo '?')"
        fi

        icon="$(color_for "$status")"
        case "$status" in
            working) sym="${SPINNER[$(( tick % 4 ))]}" ;;
            *)       sym="$(sym_for_static "$status")" ;;
        esac

        local prefix="  $window "
        local max=$(( usable - $(vlen "$prefix") - 2 ))
        [ "$max" -lt 4 ] && max=4
        if [ "$(vlen "$summary")" -gt "$max" ]; then
            summary="${summary:0:$(( max - 1 ))}…"
        fi

        add_line "$icon$sym\033[0m $prefix$summary"
    done
    [ "$found" -eq 0 ] && add_line "\033[90mno agents\033[0m"

    while [ "$lines" -lt "$height" ]; do
        add_line ""
        lines=$(( lines + 1 ))
    done

    printf "\033[H%b" "$frame"
}

mkdir -p "$STATE_DIR"
while true; do
    bash "$SCRIPT_DIR/detect.sh" 2>/dev/null || true
    build_frame 2>/dev/null || true
    tick=$(( tick + 1 ))
    sleep "$INTERVAL"
done