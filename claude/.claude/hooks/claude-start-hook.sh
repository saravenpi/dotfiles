#!/bin/bash

# Claude Code Start Hook for Garden Integration
# Registers new Claude agent session and initializes monitoring

set -euo pipefail

# Configuration
GARDEN_DIR="$HOME/.garden"
AGENTS_ACTIVE_DIR="$GARDEN_DIR/agents/active"
AGENTS_HISTORY_DIR="$GARDEN_DIR/agents/history"
PROJECTS_DIR="$GARDEN_DIR/projects"

# Ensure directories exist
mkdir -p "$AGENTS_ACTIVE_DIR" "$AGENTS_HISTORY_DIR" "$PROJECTS_DIR"

# Generate unique agent ID if not provided
if [[ -z "${CLAUDE_SESSION_ID:-}" ]]; then
    export CLAUDE_SESSION_ID="claude_$(date +%s)_$$_$(basename "$PWD" | sed 's/[^a-zA-Z0-9_-]/_/g')"
fi

AGENT_ID="$CLAUDE_SESSION_ID"
PROJECT_PATH="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_PATH")"
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")"
TASK_DESCRIPTION="${1:-Claude Code session started}"

# Detect project type
detect_project_type() {
    local project_path="$1"

    if [[ -f "$project_path/go.mod" ]]; then
        echo "go"
    elif [[ -f "$project_path/package.json" ]]; then
        if grep -q "\"react\"" "$project_path/package.json" 2>/dev/null; then
            echo "react"
        else
            echo "nodejs"
        fi
    elif [[ -f "$project_path/requirements.txt" ]] || [[ -f "$project_path/pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "$project_path/Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "$project_path/pom.xml" ]]; then
        echo "java"
    elif [[ -f "$project_path/Gemfile" ]]; then
        echo "ruby"
    else
        echo "unknown"
    fi
}

PROJECT_TYPE="$(detect_project_type "$PROJECT_PATH")"

# Get git information if available
GIT_BRANCH=""
GIT_COMMIT=""
if git rev-parse --git-dir >/dev/null 2>&1; then
    GIT_BRANCH="$(git branch --show-current 2>/dev/null || echo "detached")"
    GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")"
fi

# Create agent session data in YAML format
AGENT_DATA=$(cat <<EOF
agent_id: "$AGENT_ID"
session_id: "$AGENT_ID"
timestamp: "$TIMESTAMP"
status: "active"
project:
  name: "$PROJECT_NAME"
  path: "$PROJECT_PATH"
  type: "$PROJECT_TYPE"
  git:
    branch: "$GIT_BRANCH"
    commit: "$GIT_COMMIT"
task:
  description: "$TASK_DESCRIPTION"
  status: "started"
  progress: 0
metadata:
  created_at: "$TIMESTAMP"
  last_updated: "$TIMESTAMP"
  pid: $$
  user: "$(whoami)"
  hostname: "$(hostname)"
  claude_version: "claude-code"
  environment:
    shell: "${SHELL:-unknown}"
    term: "${TERM:-unknown}"
    lang: "${LANG:-unknown}"
logs: []
EOF
)

# Write to active agents
echo "$AGENT_DATA" > "$AGENTS_ACTIVE_DIR/$AGENT_ID.yaml"

# Create project-specific entry
PROJECT_SAFE_NAME="$(echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9_-]/_/g')"
PROJECT_SESSION_DIR="$PROJECTS_DIR/$PROJECT_SAFE_NAME"
mkdir -p "$PROJECT_SESSION_DIR"

PROJECT_SESSION_DATA=$(cat <<EOF
agent_id: "$AGENT_ID"
timestamp: "$TIMESTAMP"
task_description: "$TASK_DESCRIPTION"
status: "active"
project_path: "$PROJECT_PATH"
project_type: "$PROJECT_TYPE"
EOF
)

echo "$PROJECT_SESSION_DATA" > "$PROJECT_SESSION_DIR/$AGENT_ID.yaml"

# Log the start event
LOG_ENTRY=$(cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "level": "info",
  "event": "session_start",
  "message": "$TASK_DESCRIPTION",
  "metadata": {
    "project_type": "$PROJECT_TYPE",
    "git_branch": "$GIT_BRANCH",
    "git_commit": "$GIT_COMMIT"
  }
}
EOF
)

# Create initial log entry in YAML format
INITIAL_LOG_YAML="  - timestamp: \"$TIMESTAMP\"
    level: info
    event: session_start
    message: \"$TASK_DESCRIPTION\"
    metadata:
      project_type: \"$PROJECT_TYPE\"
      git_branch: \"$GIT_BRANCH\"
      git_commit: \"$GIT_COMMIT\""

# Create complete YAML agent data with log
FINAL_AGENT_DATA=$(cat <<EOF
agent_id: "$AGENT_ID"
session_id: "$AGENT_ID"
timestamp: "$TIMESTAMP"
status: "active"
project:
  name: "$PROJECT_NAME"
  path: "$PROJECT_PATH"
  type: "$PROJECT_TYPE"
  git:
    branch: "$GIT_BRANCH"
    commit: "$GIT_COMMIT"
task:
  description: "$TASK_DESCRIPTION"
  status: "started"
  progress: 0
metadata:
  created_at: "$TIMESTAMP"
  last_updated: "$TIMESTAMP"
  pid: $$
  user: "$(whoami)"
  hostname: "$(hostname)"
  claude_version: "claude-code"
  environment:
    shell: "${SHELL:-unknown}"
    term: "${TERM:-unknown}"
    lang: "${LANG:-unknown}"
logs:
$INITIAL_LOG_YAML
EOF
)

# Write only YAML version
echo "$FINAL_AGENT_DATA" > "$AGENTS_ACTIVE_DIR/$AGENT_ID.yaml"

# Export environment variables for other hooks
export GARDEN_AGENT_ID="$AGENT_ID"
export GARDEN_PROJECT_PATH="$PROJECT_PATH"
export GARDEN_PROJECT_TYPE="$PROJECT_TYPE"

# Output success message
echo "✅ Claude Code agent registered with Garden"
echo "   Agent ID: $AGENT_ID"
echo "   Project: $PROJECT_NAME ($PROJECT_TYPE)"
echo "   Status: Active"

# Optional: Send notification if ntfy is available
if command -v curl >/dev/null 2>&1 && [[ -n "${NTFY_SH:-}" ]]; then
    curl -s -d "🚀 Claude Code agent started in $PROJECT_NAME ($PROJECT_TYPE) - Agent ID: ${AGENT_ID:0:8}..." "$NTFY_SH" >/dev/null 2>&1 || true
fi