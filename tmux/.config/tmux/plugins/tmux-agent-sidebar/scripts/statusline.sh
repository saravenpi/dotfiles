#!/usr/bin/env bash
# Compact status-bar fragment: one colored symbol per agent pane.
# Usage in tmux.conf:  set -g status-right "#(bash ~/.tmux/plugins/tmux-agent-sidebar/scripts/statusline.sh)"

set -u

STATE_DIR="${TMUX_AGENT_SIDEBAR_DIR:-$HOME/.cache/tmux-agent-sidebar}"

out=""
for f in "$STATE_DIR"/*.json; do
    [ -f "$f" ] || continue
    status="$(sed -n 's/.*"status"[: ]*"\([^"]*\)".*/\1/p' "$f")"
    case "$status" in
        working) out="${out}#[fg=green]▸" ;;
        waiting) out="${out}#[fg=yellow]?" ;;
        done)    out="${out}#[fg=cyan]✓" ;;
        idle)    out="${out}#[fg=colour240]·" ;;
    esac
done
printf '%s' "$out"