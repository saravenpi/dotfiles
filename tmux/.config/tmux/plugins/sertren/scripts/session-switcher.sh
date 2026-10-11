#!/bin/bash

current_session=$(tmux display-message -p '#S' 2>/dev/null)
tmp_file=$(mktemp)

tmux display-popup -w 60% -h 60% -E "
    sessions=\$(tmux list-sessions -F '#{session_last_attached} #{session_name}' 2>/dev/null | sort -rn | cut -d' ' -f2-)

    {
        if [ -n '$current_session' ]; then
            echo '$current_session'
        fi

        echo \"\$sessions\" | grep -v '^$current_session\$'
    } | grep -v '^$' | fzf --prompt='Session > ' --reverse --print-query | tail -1 > $tmp_file
"

selected=$(cat "$tmp_file" 2>/dev/null)
rm -f "$tmp_file"

[ -z "$selected" ] && exit 0

if [ "$selected" = "$current_session" ]; then
    exit 0
fi

if tmux has-session -t "$selected" 2>/dev/null; then
    tmux switch-client -t "$selected"
    exit 0
fi

session_name="$selected"
project_path=$(zoxide query "$session_name" 2>/dev/null)

if [ -z "$project_path" ]; then
    project_path=$(zoxide query --list 2>/dev/null | grep -i "$session_name" | head -1)
fi

if [ -z "$project_path" ]; then
    if [ -d "$session_name" ]; then
        project_path=$(cd "$session_name" && pwd)
        zoxide add "$project_path" 2>/dev/null
    else
        project_path="$HOME"
    fi
fi

[ ! -d "$project_path" ] && project_path="$HOME"

tmux new-session -d -s "$session_name" -c "$project_path"
tmux switch-client -t "$session_name"

if [ -f "$project_path/egg.yml" ]; then
    tmux send-keys -t "$session_name" 'egg --current' Enter
fi
