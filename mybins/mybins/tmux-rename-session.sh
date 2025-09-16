#!/bin/bash

# Get current session name and use it as default
current_name=$(tmux display-message -p '#S')

# Use gum input for a clean interface
name=$(gum input --no-show-help --placeholder "New session name" --prompt "S > " --value "$current_name")

# Only rename if name is provided (gum input returns empty on ESC)
if [ -n "$name" ]; then
    tmux rename-session "$name"
fi
