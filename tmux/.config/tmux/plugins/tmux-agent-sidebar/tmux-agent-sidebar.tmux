#!/usr/bin/env bash
# tmux-agent-sidebar plugin entry point (run by TPM).

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux bind-key b run-shell "bash '$CURRENT_DIR/scripts/toggle.sh'"

# sidebar on + new window = sidebar opens in it too (auto-close is scoped
# per-window when the canvas pane is created, not via a global hook)
tmux set-hook -g after-new-window \
    "run-shell \"bash $CURRENT_DIR/scripts/ensure.sh '#S'\""

exit 0
