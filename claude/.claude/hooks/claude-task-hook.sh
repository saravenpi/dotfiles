#!/bin/bash

# Claude Code Task Hook for Garden Integration
# Logs task updates and maintains agent state

set -euo pipefail

# Configuration
GARDEN_DIR="$HOME/.garden"
AGENTS_ACTIVE_DIR="$GARDEN_DIR/agents/active"

# Check required parameters
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <task_description> <status> [progress] [additional_metadata]"
    echo "Status options: started, in_progress, blocked, completed, failed"
    exit 1
fi

TASK_DESCRIPTION="$1"
TASK_STATUS="$2"
TASK_PROGRESS="${3:-}"
ADDITIONAL_METADATA="${4:-}"

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

# Validate status
case "$TASK_STATUS" in
    started|in_progress|blocked|completed|failed|cancelled)
        ;;
    *)
        echo "❌ Error: Invalid status '$TASK_STATUS'. Valid options: started, in_progress, blocked, completed, failed, cancelled"
        exit 1
        ;;
esac

# Read current YAML data
if [[ ! -f "$AGENT_FILE" ]]; then
    echo "❌ Error: Agent file not found: $AGENT_FILE"
    exit 1
fi

# Use yq to update YAML file, or fall back to manual YAML manipulation if yq not available
if command -v yq >/dev/null 2>&1; then
    # Update using yq
    yq eval ".metadata.last_updated = \"$TIMESTAMP\"" -i "$AGENT_FILE"
    yq eval ".task.description = \"$TASK_DESCRIPTION\"" -i "$AGENT_FILE"
    yq eval ".task.status = \"$TASK_STATUS\"" -i "$AGENT_FILE"
    if [[ -n "$TASK_PROGRESS" ]]; then
        yq eval ".task.progress = $TASK_PROGRESS" -i "$AGENT_FILE"
    fi

    # Add log entry
    NEW_LOG_ENTRY="  - timestamp: \"$TIMESTAMP\"
    level: info
    event: task_update
    message: \"$TASK_DESCRIPTION\"
    task:
      description: \"$TASK_DESCRIPTION\"
      status: \"$TASK_STATUS\"
      progress: $([[ -n "$TASK_PROGRESS" ]] && echo "$TASK_PROGRESS" || echo "null")"

    if [[ -n "$ADDITIONAL_METADATA" ]]; then
        NEW_LOG_ENTRY="$NEW_LOG_ENTRY
    metadata:
      note: \"$ADDITIONAL_METADATA\""
    fi

    # Append new log entry
    echo "$NEW_LOG_ENTRY" >> "$AGENT_FILE"
else
    # Manual YAML update using sed
    sed -i.bak "s/last_updated: .*/last_updated: \"$TIMESTAMP\"/g" "$AGENT_FILE"
    sed -i.bak "s/  description: .*/  description: \"$TASK_DESCRIPTION\"/g" "$AGENT_FILE"
    sed -i.bak "s/  status: .*/  status: \"$TASK_STATUS\"/g" "$AGENT_FILE"
    if [[ -n "$TASK_PROGRESS" ]]; then
        sed -i.bak "s/  progress: .*/  progress: $TASK_PROGRESS/g" "$AGENT_FILE"
    fi

    # Add log entry manually
    NEW_LOG_ENTRY="  - timestamp: \"$TIMESTAMP\"
    level: info
    event: task_update
    message: \"$TASK_DESCRIPTION\"
    task:
      description: \"$TASK_DESCRIPTION\"
      status: \"$TASK_STATUS\"
      progress: $([[ -n "$TASK_PROGRESS" ]] && echo "$TASK_PROGRESS" || echo "null")"

    if [[ -n "$ADDITIONAL_METADATA" ]]; then
        NEW_LOG_ENTRY="$NEW_LOG_ENTRY
    metadata:
      note: \"$ADDITIONAL_METADATA\""
    fi

    echo "$NEW_LOG_ENTRY" >> "$AGENT_FILE"
    rm -f "$AGENT_FILE.bak"
fi

# Update project session if it exists
PROJECT_PATH="${GARDEN_PROJECT_PATH:-$(pwd)}"
PROJECT_NAME="$(basename "$PROJECT_PATH")"
PROJECT_SAFE_NAME="$(echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9_-]/_/g')"
PROJECT_SESSION_FILE="$GARDEN_DIR/projects/$PROJECT_SAFE_NAME/$AGENT_ID.yaml"

if [[ -f "$PROJECT_SESSION_FILE" ]]; then
    if command -v yq >/dev/null 2>&1; then
        yq eval ".timestamp = \"$TIMESTAMP\"" -i "$PROJECT_SESSION_FILE"
        yq eval ".task_description = \"$TASK_DESCRIPTION\"" -i "$PROJECT_SESSION_FILE"
        yq eval ".status = \"$TASK_STATUS\"" -i "$PROJECT_SESSION_FILE"
    else
        sed -i.bak "s/timestamp: .*/timestamp: \"$TIMESTAMP\"/g" "$PROJECT_SESSION_FILE"
        sed -i.bak "s/task_description: .*/task_description: \"$TASK_DESCRIPTION\"/g" "$PROJECT_SESSION_FILE"
        sed -i.bak "s/status: .*/status: \"$TASK_STATUS\"/g" "$PROJECT_SESSION_FILE"
        rm -f "$PROJECT_SESSION_FILE.bak"
    fi
fi

# Output status based on task status
case "$TASK_STATUS" in
    started)
        echo "🚀 Task started: $TASK_DESCRIPTION"
        ;;
    in_progress)
        PROGRESS_MSG=""
        if [[ -n "$TASK_PROGRESS" ]]; then
            PROGRESS_MSG=" (${TASK_PROGRESS}%)"
        fi
        echo "⚡ Task in progress: $TASK_DESCRIPTION$PROGRESS_MSG"
        ;;
    blocked)
        echo "⚠️  Task blocked: $TASK_DESCRIPTION"
        ;;
    completed)
        echo "✅ Task completed: $TASK_DESCRIPTION"
        ;;
    failed)
        echo "❌ Task failed: $TASK_DESCRIPTION"
        ;;
    cancelled)
        echo "🚫 Task cancelled: $TASK_DESCRIPTION"
        ;;
esac

# Optional: Send notification for important status changes
if command -v curl >/dev/null 2>&1 && [[ -n "${NTFY_SH:-}" ]]; then
    case "$TASK_STATUS" in
        completed)
            curl -s -d "✅ Task completed: $TASK_DESCRIPTION (Agent: ${AGENT_ID:0:8}...)" "$NTFY_SH" >/dev/null 2>&1 || true
            ;;
        failed)
            curl -s -d "❌ Task failed: $TASK_DESCRIPTION (Agent: ${AGENT_ID:0:8}...)" "$NTFY_SH" >/dev/null 2>&1 || true
            ;;
        blocked)
            curl -s -d "⚠️ Task blocked: $TASK_DESCRIPTION (Agent: ${AGENT_ID:0:8}...)" "$NTFY_SH" >/dev/null 2>&1 || true
            ;;
    esac
fi