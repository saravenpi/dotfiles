#!/bin/bash

# tmux session switcher - shows only active sessions
# Type a new name to create a session with zoxide path

tmux_session_switcher() {
    local current_session=""
    local sessions=()
    local all_options=()

    # Get current tmux session if we're in one
    if [ -n "$TMUX" ]; then
        current_session=$(tmux display-message -p '#S')
    fi

    # Get existing tmux sessions ordered by last activity (most recent first)
    while IFS= read -r line; do
        local session=$(echo "$line" | cut -d: -f1)
        if [ "$session" != "$current_session" ]; then
            sessions+=("$session")
            all_options+=("$session")
        fi
    done < <(tmux list-sessions -F "#{session_last_attached} #{session_name}" 2>/dev/null | sort -rn | cut -d' ' -f2-)

    # Add current session at the top if we have one
    if [ -n "$current_session" ]; then
        all_options=("$current_session (current)" "${all_options[@]}")
    fi

    # Write options to a temp file
    local temp_file="/tmp/tmux-session-options-$$"
    printf '%s\n' "${all_options[@]}" > "$temp_file"

    # Use fzf in popup and capture result
    tmux popup -w 40% -h 40% -E "
        # Source shell configuration to ensure zoxide is available
        [ -f ~/.zshrc ] && source ~/.zshrc >/dev/null 2>&1

        fzf_result=\$(cat '$temp_file' | fzf \
            --prompt='Session: ' \
            --height=100% \
            --layout=default \
            --no-sort \
            -i \
            --print-query \
            --bind='tab:accept,esc:abort,enter:accept' \
            --color='border:#A4AF46,header:#C59C86,prompt:#C8D062')

        # Handle fzf result - if there are 2 lines, use the second (selection)
        # If there's only 1 line, use it as the query (typed input)
        if [ \$(echo \"\$fzf_result\" | wc -l) -eq 2 ]; then
            selection=\$(echo \"\$fzf_result\" | tail -1)
        else
            selection=\$(echo \"\$fzf_result\" | head -1)
        fi

        # Clean up temp file
        rm -f '$temp_file'

        # If selection was made, switch to it
        if [ -n \"\$selection\" ]; then
            # Handle current session selection
            if [[ \"\$selection\" == *\"(current)\" ]]; then
                exit 0
            fi

            # Clean the selection (remove any leading/trailing spaces and (current) suffix)
            session_name=\$(echo \"\$selection\" | sed 's/ (current)$//' | xargs)

            # Check if it's an existing session
            if tmux has-session -t \"\$session_name\" 2>/dev/null; then
                tmux switch-client -t \"\$session_name\"
                exit 0
            fi

            # If selection doesn't exist, treat as new session name
            # Try to get path from zoxide
            project_path=\$(zoxide query \"\$session_name\" 2>/dev/null)

            # If no exact match, try listing all and grep for partial matches
            if [ -z \"\$project_path\" ]; then
                project_path=\$(zoxide query --list | grep -i \"\$session_name\" | head -1)
            fi

            # If still no match, check if it's a valid directory path or use current directory
            if [ -z \"\$project_path\" ]; then
                # Check if session_name is a valid directory path
                if [ -d \"\$session_name\" ]; then
                    project_path=\$(cd \"\$session_name\" && pwd)
                    zoxide add \"\$project_path\" 2>/dev/null
                else
                    # Fallback to home directory
                    project_path=\"\$HOME\"
                fi
            fi

            # Create new session with the determined path
            # Ensure we have a valid directory
            if [ ! -d \"\$project_path\" ]; then
                project_path=\"\$HOME\"
            fi

            # Create the new session
            tmux new-session -d -s \"\$session_name\" -c \"\$project_path\"
            tmux switch-client -t \"\$session_name\"
            # Apply the tmux layout with egg --current if egg.yml exists
            if [ -f \"\$project_path/egg.yml\" ]; then
                tmux send-keys -t \"\$session_name\" 'egg --current' Enter
            fi
        fi
    "
}

# Run the function
tmux_session_switcher
