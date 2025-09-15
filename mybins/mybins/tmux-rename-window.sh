#!/bin/bash

# Get current window name and use it as default
current_name=$(tmux display-message -p '#W')

# Use gum input for a clean interface
name=$(gum input --no-show-help --placeholder "New window name" --value "$current_name")

# Only rename if name is provided (gum input returns empty on ESC)
if [ -n "$name" ]; then
    tmux rename-window "$name"
fi