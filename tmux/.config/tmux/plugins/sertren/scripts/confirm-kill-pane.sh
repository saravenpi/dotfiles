#!/bin/bash

tmux display-popup -E -w 50 -h 5 '
    printf "\n  Kill this pane? [Y/n]: "
    read -rsn1 answer
    answer=${answer:-y}
    answer=$(echo "$answer" | tr "[:upper:]" "[:lower:]")

    if [ "$answer" = "y" ]; then
        tmux kill-pane
    fi
'
