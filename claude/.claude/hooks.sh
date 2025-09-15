#!/bin/bash

# Garden Claude Code Hooks Configuration
# This file is sourced by Claude Code to enable Garden integration

# Check if hooks are available
if [[ -d "$HOME/.local/bin/garden-hooks" ]]; then
    export GARDEN_HOOKS_ENABLED=true
    export GARDEN_HOOKS_DIR="$HOME/.local/bin/garden-hooks"

    # Auto-register session with Garden when Claude Code starts
    if [[ -z "${GARDEN_AGENT_ID:-}" && -z "${CLAUDE_SESSION_ID:-}" ]]; then
        export CLAUDE_SESSION_ID="claude_$(date +%s)_$$_$(basename "$PWD" | sed 's/[^a-zA-Z0-9_-]/_/g')"
        export GARDEN_AGENT_ID="$CLAUDE_SESSION_ID"

        # Register the session
        "$GARDEN_HOOKS_DIR/claude-start-hook.sh" "Claude Code session started in $(basename "$PWD")" >/dev/null 2>&1 || true
    fi

    # Helper functions for easy hook usage
    garden_task() {
        local description="$1"
        local status="${2:-started}"
        local progress="${3:-}"
        local metadata="${4:-}"
        "$GARDEN_HOOKS_DIR/claude-task-hook.sh" "$description" "$status" "$progress" "$metadata" 2>/dev/null || true
    }

    garden_progress() {
        local progress="$1"
        local step_description="${2:-}"
        local total_steps="${3:-}"
        local current_step="${4:-}"
        "$GARDEN_HOOKS_DIR/claude-progress-hook.sh" "$progress" "$step_description" "$total_steps" "$current_step" 2>/dev/null || true
    }

    garden_complete() {
        local message="${1:-Task completed successfully}"
        local summary="${2:-}"
        local success="${3:-true}"
        "$GARDEN_HOOKS_DIR/claude-complete-hook.sh" "$message" "$summary" "$success" 2>/dev/null || true
    }

    garden_error() {
        local message="$1"
        local type="${2:-recoverable}"
        local code="${3:-}"
        local context="${4:-}"
        local stack="${5:-}"
        "$GARDEN_HOOKS_DIR/claude-error-hook.sh" "$message" "$type" "$code" "$context" "$stack" 2>/dev/null || true
    }

    # Alias for convenience
    alias gtask='garden_task'
    alias gprog='garden_progress'
    alias gcomplete='garden_complete'
    alias gerror='garden_error'

    # Garden hooks are now enabled silently
else
    export GARDEN_HOOKS_ENABLED=false
fi
