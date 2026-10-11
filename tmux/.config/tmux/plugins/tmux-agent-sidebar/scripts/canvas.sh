#!/usr/bin/env bash
# run process detection in the background, render frames with the Go canvas
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
interval="${TMUX_AGENT_SIDEBAR_INTERVAL:-1}"

bin="$ROOT/sidebar"
[ -x "$bin" ] || bin="$SCRIPT_DIR/sidebar.sh"

trap 'kill $det_pid 2>/dev/null' EXIT
while true; do
    bash "$SCRIPT_DIR/detect.sh" 2>/dev/null || true
    sleep "$interval"
done &
det_pid=$!

exec "$bin"
