#!/bin/bash

current_name=$(tmux display-message -p '#S')
tmux command-prompt -I "$current_name" -p "Rename session:" "rename-session '%%'"
