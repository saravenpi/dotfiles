#!/bin/sh
target=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | awk '$2 == "yazi" {print $1; exit}')
if [ -n "$target" ]; then
	tmux kill-pane -t "$target"
	exit 0
fi

path="${1:-$PWD}"
if [ -f "$path" ]; then
	dir=$(dirname "$path")
	tmux split-window -h -b -l 45 -c "$dir" "yazi '$path'"
elif [ -d "$path" ]; then
	tmux split-window -h -b -l 45 -c "$path" "yazi"
else
	tmux split-window -h -b -l 45 "yazi"
fi
