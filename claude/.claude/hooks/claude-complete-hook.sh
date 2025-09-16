#!/bin/bash

# Claude Code Complete Hook for Garden Integration
# Marks tasks as complete and archives agent session

set -euo pipefail

# Configuration
GARDEN_DIR="$HOME/.garden"
AGENTS_ACTIVE_DIR="$GARDEN_DIR/agents/active"
AGENTS_HISTORY_DIR="$GARDEN_DIR/agents/history"

# Check parameters
COMPLETION_MESSAGE="${1:-Task completed successfully}"
COMPLETION_SUMMARY="${2:-}"
SUCCESS="${3:-true}"

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
if command -v yq >/dev/null 2>&1; then
    START_TIME=$(yq eval '.metadata.created_at' "$AGENT_FILE")
else
    START_TIME=$(grep 'created_at:' "$AGENT_FILE" | sed 's/.*created_at: "\(.*\)"/\1/')
fi

# Calculate duration
if command -v date >/dev/null 2>&1; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        START_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${START_TIME%.*}" "+%s" 2>/dev/null || echo "0")
        END_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${TIMESTAMP%.*}" "+%s" 2>/dev/null || echo "0")
    else
        # Linux
        START_EPOCH=$(date -d "$START_TIME" +%s 2>/dev/null || echo "0")
        END_EPOCH=$(date -d "$TIMESTAMP" +%s 2>/dev/null || echo "0")
    fi
    DURATION=$((END_EPOCH - START_EPOCH))
else
    DURATION=0
fi

# Format duration as human readable
format_duration() {
    local duration=$1
    local hours=$((duration / 3600))
    local minutes=$(((duration % 3600) / 60))
    local seconds=$((duration % 60))

    if [[ $hours -gt 0 ]]; then
        echo "${hours}h ${minutes}m ${seconds}s"
    elif [[ $minutes -gt 0 ]]; then
        echo "${minutes}m ${seconds}s"
    else
        echo "${seconds}s"
    fi
}

DURATION_FORMATTED="$(format_duration "$DURATION")"

# Determine completion status
if [[ "$SUCCESS" == "true" ]]; then
    COMPLETION_STATUS="completed"
    STATUS_ICON="✅"
    FINAL_PROGRESS=100
else
    COMPLETION_STATUS="failed"
    STATUS_ICON="❌"
    FINAL_PROGRESS=0
fi

# Create completion log entry in YAML format
COMPLETION_LOG_YAML="  - timestamp: \"$TIMESTAMP\"
    level: info
    event: session_complete
    message: \"$COMPLETION_MESSAGE\"
    completion:
      status: \"$COMPLETION_STATUS\"
      success: $SUCCESS
      duration_seconds: $DURATION
      duration_formatted: \"$DURATION_FORMATTED\""

if [[ -n "$COMPLETION_SUMMARY" ]]; then
    COMPLETION_LOG_YAML="$COMPLETION_LOG_YAML
      summary: \"$COMPLETION_SUMMARY\""
fi

# Create complete YAML data for completed agent
if command -v yq >/dev/null 2>&1; then
    # Update using yq
    yq eval ".status = \"$COMPLETION_STATUS\"" -i "$AGENT_FILE"
    yq eval ".metadata.last_updated = \"$TIMESTAMP\"" -i "$AGENT_FILE"
    yq eval ".metadata.completed_at = \"$TIMESTAMP\"" -i "$AGENT_FILE"
    yq eval ".metadata.duration_seconds = $DURATION" -i "$AGENT_FILE"
    yq eval ".metadata.duration_formatted = \"$DURATION_FORMATTED\"" -i "$AGENT_FILE"
    yq eval ".task.status = \"$COMPLETION_STATUS\"" -i "$AGENT_FILE"
    yq eval ".task.progress = $FINAL_PROGRESS" -i "$AGENT_FILE"
    yq eval ".task.completion_message = \"$COMPLETION_MESSAGE\"" -i "$AGENT_FILE"
    yq eval ".task.success = $SUCCESS" -i "$AGENT_FILE"

    if [[ -n "$COMPLETION_SUMMARY" ]]; then
        yq eval ".task.summary = \"$COMPLETION_SUMMARY\"" -i "$AGENT_FILE"
    fi
else
    # Manual YAML update using sed
    sed -i.bak "s/status: .*/status: \"$COMPLETION_STATUS\"/g" "$AGENT_FILE"
    sed -i.bak "s/last_updated: .*/last_updated: \"$TIMESTAMP\"/g" "$AGENT_FILE"
    sed -i.bak "s/  status: .*/  status: \"$COMPLETION_STATUS\"/g" "$AGENT_FILE"
    sed -i.bak "s/  progress: .*/  progress: $FINAL_PROGRESS/g" "$AGENT_FILE"

    # Add completion metadata
    sed -i.bak "/last_updated:/a\\
  completed_at: \"$TIMESTAMP\"\\
  duration_seconds: $DURATION\\
  duration_formatted: \"$DURATION_FORMATTED\"" "$AGENT_FILE"

    # Add completion task data
    sed -i.bak "/  progress: $FINAL_PROGRESS/a\\
  completion_message: \"$COMPLETION_MESSAGE\"\\
  success: $SUCCESS" "$AGENT_FILE"

    if [[ -n "$COMPLETION_SUMMARY" ]]; then
        sed -i.bak "/  success: $SUCCESS/a\\
  summary: \"$COMPLETION_SUMMARY\"" "$AGENT_FILE"
    fi

    rm -f "$AGENT_FILE.bak"
fi

# Add completion log entry
echo "$COMPLETION_LOG_YAML" >> "$AGENT_FILE"

# Move to history
cp "$AGENT_FILE" "$AGENTS_HISTORY_DIR/$AGENT_ID.yaml"
rm -f "$AGENT_FILE"

# Update project session
PROJECT_PATH="${GARDEN_PROJECT_PATH:-$(pwd)}"
PROJECT_NAME="$(basename "$PROJECT_PATH")"
PROJECT_SAFE_NAME="$(echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9_-]/_/g')"
PROJECT_SESSION_FILE="$GARDEN_DIR/projects/$PROJECT_SAFE_NAME/$AGENT_ID.yaml"

if [[ -f "$PROJECT_SESSION_FILE" ]]; then
    if command -v yq >/dev/null 2>&1; then
        yq eval ".timestamp = \"$TIMESTAMP\"" -i "$PROJECT_SESSION_FILE"
        yq eval ".status = \"$COMPLETION_STATUS\"" -i "$PROJECT_SESSION_FILE"
        yq eval ".completed_at = \"$TIMESTAMP\"" -i "$PROJECT_SESSION_FILE"
        yq eval ".duration_seconds = $DURATION" -i "$PROJECT_SESSION_FILE"
        yq eval ".duration_formatted = \"$DURATION_FORMATTED\"" -i "$PROJECT_SESSION_FILE"
    else
        sed -i.bak "s/timestamp: .*/timestamp: \"$TIMESTAMP\"/g" "$PROJECT_SESSION_FILE"
        sed -i.bak "s/status: .*/status: \"$COMPLETION_STATUS\"/g" "$PROJECT_SESSION_FILE"
        sed -i.bak "/timestamp:/a\\
completed_at: \"$TIMESTAMP\"\\
duration_seconds: $DURATION\\
duration_formatted: \"$DURATION_FORMATTED\"" "$PROJECT_SESSION_FILE"
        rm -f "$PROJECT_SESSION_FILE.bak"
    fi
fi

# Generate completion report
echo ""
echo "════════════════════════════════════════"
echo "$STATUS_ICON Claude Code Session Complete"
echo "════════════════════════════════════════"
echo "Agent ID: $AGENT_ID"
echo "Project: $PROJECT_NAME"
echo "Duration: $DURATION_FORMATTED"
echo "Status: $COMPLETION_STATUS"
echo "Message: $COMPLETION_MESSAGE"
if [[ -n "$COMPLETION_SUMMARY" ]]; then
    echo ""
    echo "Summary:"
    echo "$COMPLETION_SUMMARY"
fi
echo ""

# Get task count from logs (using grep on YAML)
TASK_COUNT=$(grep -c 'event: task_update' "$AGENT_FILE" || echo "0")
echo "📊 Tasks processed: $TASK_COUNT"

# Count log events (using grep on YAML)
ERROR_COUNT=$(grep -c 'level: error' "$AGENT_FILE" || echo "0")
WARNING_COUNT=$(grep -c 'level: warn' "$AGENT_FILE" || echo "0")

if [[ "$ERROR_COUNT" -gt 0 ]]; then
    echo "❌ Errors encountered: $ERROR_COUNT"
fi
if [[ "$WARNING_COUNT" -gt 0 ]]; then
    echo "⚠️ Warnings: $WARNING_COUNT"
fi

echo "════════════════════════════════════════"

# Clean up environment variables
unset GARDEN_AGENT_ID GARDEN_PROJECT_PATH GARDEN_PROJECT_TYPE

# Send completion notification
if command -v curl >/dev/null 2>&1 && [[ -n "${NTFY_SH:-}" ]]; then
    NOTIFICATION_MESSAGE="$STATUS_ICON Claude Code session completed in $PROJECT_NAME"
    NOTIFICATION_MESSAGE="$NOTIFICATION_MESSAGE - Duration: $DURATION_FORMATTED"
    if [[ "$TASK_COUNT" -gt 0 ]]; then
        NOTIFICATION_MESSAGE="$NOTIFICATION_MESSAGE - Tasks: $TASK_COUNT"
    fi
    if [[ -n "$COMPLETION_SUMMARY" ]]; then
        NOTIFICATION_MESSAGE="$NOTIFICATION_MESSAGE - $COMPLETION_SUMMARY"
    fi

    curl -s -d "$NOTIFICATION_MESSAGE" "$NTFY_SH" >/dev/null 2>&1 || true
fi