#!/usr/bin/env bash
# Toggle the agent sidebar across every window of the current session.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKER="canvas.sh"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

session="$(tmux display-message -p '#{session_name}')"
interval="$(tmux show-option -gv @tmux-agent-sidebar-interval 2>/dev/null || echo 2)"
width="$(tmux show-option -gv @tmux-agent-sidebar-width 2>/dev/null || echo 28)"

is_on() {
    [ "$(tmux show-options -v -t "$session" "@agent-sidebar-on-$session" 2>/dev/null)" = "1" ] \
        || tmux list-panes -t "$session" -F '#{pane_start_command}' 2>/dev/null | grep -q "$MARKER"
}

# kill sidebar panes in every window of the session, not just the current one
kill_all() {
    for window in $(tmux list-windows -t "$session" -F '#{window_id}'); do
        for pane in $(tmux list-panes -t "$window" -F '#{pane_id} #{pane_start_command}' 2>/dev/null \
            | grep "$MARKER" | awk '{print $1}'); do
            tmux kill-pane -t "$pane" 2>/dev/null
        done
    done
}

open_all() {
    # build the Go canvas if the toolchain is present; bash fallback otherwise
    bin="$ROOT/sidebar"
    if [ ! -x "$bin" ] || [ "$ROOT/cmd/sidebar/main.go" -nt "$bin" ]; then
        (cd "$ROOT" && go build -o sidebar ./cmd/sidebar 2>/dev/null) || true
    fi
    if [ ! -x "$bin" ]; then
        bin="$SCRIPT_DIR/sidebar.sh"
    fi

    for window in $(tmux list-windows -t "$session" -F '#{window_id}'); do
        tmux list-panes -t "$window" -F '#{pane_start_command}' 2>/dev/null | grep -q "$MARKER" && continue
        # history-limit 1: the sidebar pane keeps no scrollback
        history_limit="$(tmux show-options -gv history-limit 2>/dev/null || echo 2000)"
        tmux set-option -w -t "$window" history-limit 1
        left="$(tmux list-panes -t "$window" -F '#{pane_id} #{pane_left}' | sort -k2 -n | head -1 | awk '{print $1}')"
        tmux split-window -h -b -l "$width" -t "$left" \
            "TMUX_AGENT_SIDEBAR_INTERVAL='$interval' bash '$SCRIPT_DIR/canvas.sh'"
        tmux set-option -w -t "$window" history-limit "$history_limit"
        # scope auto-close to this window; autoclose never kills a session
        tmux set-hook -w -t "$window" pane-exited \
            "run-shell 'bash $SCRIPT_DIR/autoclose.sh $window'"
        # sidebar pane is leftmost; put focus back on the first non-canvas pane
        panes="$(tmux list-panes -t "$window" -F '#{pane_id} #{pane_left}' \
            | sort -k2 -n | awk '$2 > 0 {print $1}')"
        for pane in $panes; do
            tmux select-pane -t "$pane" && break
        done
    done
}

if is_on; then
    kill_all
    tmux set-option -u "@agent-sidebar-on-$session" 2>/dev/null
else
    open_all
    tmux set-option "@agent-sidebar-on-$session" 1
fi