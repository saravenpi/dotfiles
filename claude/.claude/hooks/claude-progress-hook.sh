#!/bin/bash

# Claude Code Progress Hook for Garden Integration
# Updates task progress and maintains detailed progress tracking

set -euo pipefail

# Configuration
GARDEN_DIR="$HOME/.garden"
AGENTS_ACTIVE_DIR="$GARDEN_DIR/agents/active"

# Check required parameters
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <progress_percentage> [step_description] [total_steps] [current_step]"
    echo "Progress percentage: 0-100"
    exit 1
fi

PROGRESS="$1"
STEP_DESCRIPTION="${2:-}"
TOTAL_STEPS="${3:-}"
CURRENT_STEP="${4:-}"

# Validate progress percentage
if ! [[ "$PROGRESS" =~ ^[0-9]+$ ]] || [[ "$PROGRESS" -lt 0 ]] || [[ "$PROGRESS" -gt 100 ]]; then
    echo "❌ Error: Progress must be a number between 0 and 100"
    exit 1
fi

# Get agent ID from environment
AGENT_ID="${GARDEN_AGENT_ID:-${CLAUDE_SESSION_ID:-}}"
if [[ -z "$AGENT_ID" ]]; then
    echo "❌ Error: No agent ID found. Make sure claude-start-hook.sh was called first."
    exit 1
fi

AGENT_FILE="$AGENTS_ACTIVE_DIR/$AGENT_ID.yaml"
if [[ ! -f "$AGENT_FILE" ]]; then
    echo "❌ Error: Agent file not found: $AGENT_FILE"
    exit 1
fi

TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")"

# Update YAML file with progress information
if command -v yq >/dev/null 2>&1; then
    # Update using yq
    yq eval ".metadata.last_updated = \"$TIMESTAMP\"" -i "$AGENT_FILE"
    yq eval ".task.progress = $PROGRESS" -i "$AGENT_FILE"

    # Add progress details if provided
    if [[ -n "$STEP_DESCRIPTION" ]]; then
        yq eval ".task.progress_details.step_description = \"$STEP_DESCRIPTION\"" -i "$AGENT_FILE"
    fi
    if [[ -n "$TOTAL_STEPS" ]]; then
        yq eval ".task.progress_details.total_steps = $TOTAL_STEPS" -i "$AGENT_FILE"
    fi
    if [[ -n "$CURRENT_STEP" ]]; then
        yq eval ".task.progress_details.current_step = $CURRENT_STEP" -i "$AGENT_FILE"
    fi

    # Add log entry
    NEW_LOG_ENTRY="  - timestamp: \"$TIMESTAMP\"
    level: info
    event: progress_update
    message: $(if [[ -n "$STEP_DESCRIPTION" ]]; then echo "\"Progress: $PROGRESS% - $STEP_DESCRIPTION\""; else echo "\"Progress: $PROGRESS%\""; fi)
    progress:
      progress: $PROGRESS
      step_description: $(if [[ -n "$STEP_DESCRIPTION" ]]; then echo "\"$STEP_DESCRIPTION\""; else echo "null"; fi)
      total_steps: $(if [[ -n "$TOTAL_STEPS" ]]; then echo "$TOTAL_STEPS"; else echo "null"; fi)
      current_step: $(if [[ -n "$CURRENT_STEP" ]]; then echo "$CURRENT_STEP"; else echo "null"; fi)"

    # Append new log entry
    echo "$NEW_LOG_ENTRY" >> "$AGENT_FILE"
else
    # Manual YAML update using sed
    sed -i.bak "s/last_updated: .*/last_updated: \"$TIMESTAMP\"/g" "$AGENT_FILE"
    sed -i.bak "s/  progress: .*/  progress: $PROGRESS/g" "$AGENT_FILE"

    # Add log entry manually
    NEW_LOG_ENTRY="  - timestamp: \"$TIMESTAMP\"
    level: info
    event: progress_update
    message: $(if [[ -n "$STEP_DESCRIPTION" ]]; then echo "\"Progress: $PROGRESS% - $STEP_DESCRIPTION\""; else echo "\"Progress: $PROGRESS%\""; fi)
    progress:
      progress: $PROGRESS
      step_description: $(if [[ -n "$STEP_DESCRIPTION" ]]; then echo "\"$STEP_DESCRIPTION\""; else echo "null"; fi)
      total_steps: $(if [[ -n "$TOTAL_STEPS" ]]; then echo "$TOTAL_STEPS"; else echo "null"; fi)
      current_step: $(if [[ -n "$CURRENT_STEP" ]]; then echo "$CURRENT_STEP"; else echo "null"; fi)"

    echo "$NEW_LOG_ENTRY" >> "$AGENT_FILE"
    rm -f "$AGENT_FILE.bak"
fi

# Generate progress bar for visual feedback
generate_progress_bar() {
    local progress=$1
    local width=20
    local filled=$((progress * width / 100))
    local empty=$((width - filled))

    printf "["
    printf "%*s" "$filled" | tr ' ' '█'
    printf "%*s" "$empty" | tr ' ' '░'
    printf "] %d%%" "$progress"
}

# Output progress update
PROGRESS_BAR="$(generate_progress_bar "$PROGRESS")"
if [[ -n "$STEP_DESCRIPTION" ]]; then
    if [[ -n "$CURRENT_STEP" && -n "$TOTAL_STEPS" ]]; then
        echo "📊 Progress: $PROGRESS_BAR ($CURRENT_STEP/$TOTAL_STEPS) - $STEP_DESCRIPTION"
    else
        echo "📊 Progress: $PROGRESS_BAR - $STEP_DESCRIPTION"
    fi
else
    echo "📊 Progress: $PROGRESS_BAR"
fi

# Optional: Send notification on significant progress milestones
if command -v curl >/dev/null 2>&1 && [[ -n "${NTFY_SH:-}" ]]; then
    # Send notifications at 25%, 50%, 75%, and 100%
    case "$PROGRESS" in
        25|50|75|100)
            MESSAGE="📊 Progress: ${PROGRESS}%"
            if [[ -n "$STEP_DESCRIPTION" ]]; then
                MESSAGE="$MESSAGE - $STEP_DESCRIPTION"
            fi
            MESSAGE="$MESSAGE (Agent: ${AGENT_ID:0:8}...)"
            curl -s -d "$MESSAGE" "$NTFY_SH" >/dev/null 2>&1 || true
            ;;
    esac
fi

# Update project session progress if it exists
PROJECT_PATH="${GARDEN_PROJECT_PATH:-$(pwd)}"
PROJECT_NAME="$(basename "$PROJECT_PATH")"
PROJECT_SAFE_NAME="$(echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9_-]/_/g')"
PROJECT_SESSION_FILE="$GARDEN_DIR/projects/$PROJECT_SAFE_NAME/$AGENT_ID.yaml"

if [[ -f "$PROJECT_SESSION_FILE" ]]; then
    if command -v yq >/dev/null 2>&1; then
        yq eval ".timestamp = \"$TIMESTAMP\"" -i "$PROJECT_SESSION_FILE"
        yq eval ".progress = $PROGRESS" -i "$PROJECT_SESSION_FILE"
    else
        sed -i.bak "s/timestamp: .*/timestamp: \"$TIMESTAMP\"/g" "$PROJECT_SESSION_FILE"
        sed -i.bak "s/progress: .*/progress: $PROGRESS/g" "$PROJECT_SESSION_FILE"
        rm -f "$PROJECT_SESSION_FILE.bak"
    fi
fi