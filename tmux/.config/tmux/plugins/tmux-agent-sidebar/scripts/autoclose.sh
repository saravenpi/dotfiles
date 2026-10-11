#!/usr/bin/env bash
# When the sidebar canvas is the only pane left in a window, close the window
# with it — but never the last window of a session, so a hook chain can never
# kill a whole session. Called with the window id by the per-window pane-exited
# hook set in toggle.sh / ensure.sh; with no argument it does nothing.

set -euo pipefail

MARKER="canvas.sh"
window="${1:-}"
[ -n "$window" ] || exit 0

session="$(tmux display-message -p -t "$window" '#{session_id}' 2>/dev/null)" || exit 0
[ -n "$session" ] || exit 0

[ "$(tmux list-panes -t "$window" -F '#{pane_id}' 2>/dev/null | wc -l)" -eq 1 ] || exit 0
tmux list-panes -t "$window" -F '#{pane_start_command}' 2>/dev/null | grep -q "$MARKER" || exit 0

window_count="$(tmux list-windows -t "$session" -F '#{window_id}' 2>/dev/null | wc -l)"
[ "$window_count" -gt 1 ] || exit 0

tmux kill-window -t "$window" 2>/dev/null || true
