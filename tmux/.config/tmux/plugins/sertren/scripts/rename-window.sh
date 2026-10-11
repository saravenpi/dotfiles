#!/bin/bash

current_name=$(tmux display-message -p '#W')
tmux command-prompt -I "$current_name" -p "Rename window:" "rename-window '%%'"
