#!/usr/bin/env bash
# Open a sidebar in every window of the given session that lacks one.
# Called by after-new-window when the session's sidebar is on.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
session="${1:-$(tmux display-message -p '#{session_name}' 2>/dev/null)}"
[ -n "$session" ] || exit 0

[ "$(tmux show-options -v -t "$session" "@agent-sidebar-on-$session" 2>/dev/null)" = "1" ] || exit 0

width="$(tmux show-option -gv @tmux-agent-sidebar-width 2>/dev/null || echo 28)"
interval="$(tmux show-option -gv @tmux-agent-sidebar-interval 2>/dev/null || echo 2)"

for window in $(tmux list-windows -t "$session" -F '#{window_id}' 2>/dev/null); do
    tmux list-panes -t "$window" -F '#{pane_start_command}' 2>/dev/null | grep -q canvas.sh && continue
    left="$(tmux list-panes -t "$window" -F '#{pane_id} #{pane_left}' | sort -k2 -n | head -1 | awk '{print $1}')"
    tmux split-window -h -b -l "$width" -t "$left" \
        "TMUX_AGENT_SIDEBAR_INTERVAL='$interval' bash '$SCRIPT_DIR/canvas.sh'"
    tmux set-hook -w -t "$window" pane-exited \
        "run-shell 'bash $SCRIPT_DIR/autoclose.sh $window'"
    panes="$(tmux list-panes -t "$window" -F '#{pane_id} #{pane_left}' \
        | sort -k2 -n | awk '$2 > 0 {print $1}')"
    for pane in $panes; do
        tmux select-pane -t "$pane" && break
    done
done