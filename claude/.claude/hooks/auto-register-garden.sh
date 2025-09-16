#!/bin/bash

# Auto-register Claude Code session with Garden if not already registered
# This can be used in your shell profile or called manually

GARDEN_DIR="$HOME/.garden"
AGENTS_ACTIVE_DIR="$GARDEN_DIR/agents/active"

# Check if there's already an active session for this shell session
current_pid=$$
current_project="$(basename "$(pwd)")"
session_pattern="*${current_project}*.yaml"

# Look for existing session
existing_session=$(find "$AGENTS_ACTIVE_DIR" -name "$session_pattern" -newer 1h 2>/dev/null | head -1)

if [[ -z "$existing_session" ]]; then
    # No recent session found, register new one
    echo "🌱 Registering Claude Code session with Garden..."
    ~/.claude/hooks/claude-start-hook.sh "Claude Code session in $(basename "$(pwd)")"
else
    echo "✅ Garden session already active for this project"
fi