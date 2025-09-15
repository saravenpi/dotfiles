#!/bin/bash
selection="$1"

# Function to create session for project
create_session_for_project() {
    local input_name="$1"
    local project_path="$2"
    
    # Create session name (replace dots and special chars with underscores)
    local session_name=$(echo "$input_name" | tr '.' '_' | tr '-' '_')

    # Check if session already exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
        if [ -n "$TMUX" ]; then
            tmux switch-client -t "$session_name"
        else
            tmux attach-session -t "$session_name"
        fi
    else
        # Create new session in the project directory
        if [ -n "$TMUX" ]; then
            tmux new-session -d -s "$session_name" -c "$project_path"
            tmux switch-client -t "$session_name"
        else
            tmux new-session -s "$session_name" -c "$project_path"
        fi
        
        # Open the project with egg if available
        if command -v egg >/dev/null 2>&1; then
            tmux send-keys -t "$session_name" "egg" C-m
        fi
    fi
}

# Handle empty selection (user pressed escape)
if [ -z "$selection" ]; then
    exit 0
fi

# Handle current session selection
if [[ "$selection" == "🔄"* ]]; then
    exit 0
fi

# Handle existing session selection
if [[ "$selection" == "🪟"* ]]; then
    session_name=$(echo "$selection" | sed 's/^🪟 //')
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
    exit 0
fi

# Handle project selection
if [[ "$selection" == "📁"* ]]; then
    project_name=$(echo "$selection" | sed 's/^📁 //')
    project_path=$(zoxide query "$project_name")
    
    if [ -n "$project_path" ]; then
        create_session_for_project "$project_name" "$project_path"
    else
        tmux display-message "Project path not found for: $project_name"
    fi
    exit 0
fi

# If selection doesn't match any pattern, try zoxide query directly
project_path=$(zoxide query "$selection" 2>/dev/null)

# If no exact match, try listing all and grep for partial matches
if [ -z "$project_path" ]; then
    project_path=$(zoxide query --list | grep -i "$selection" | head -1)
fi

# If still no match, check if it's a valid directory path or use current directory
if [ -z "$project_path" ]; then
    # Check if selection is a valid directory path
    if [ -d "$selection" ]; then
        project_path=$(cd "$selection" && pwd)
        zoxide add "$project_path" 2>/dev/null
    else
        # Fallback to current directory
        project_path="$PWD"
    fi
fi

# Create new session with the determined path
# Ensure we have a valid directory
if [ ! -d "$project_path" ]; then
    project_path="$HOME"
fi

create_session_for_project "$selection" "$project_path"
