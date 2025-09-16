#!/usr/bin/env bash

# WISP Menu for tmux integration
WORK_LOG="$HOME/.wisp.yml"

# Check if we're in tmux
if [ -z "$TMUX" ]; then
    echo "Error: This menu must be run from within tmux"
    exit 1
fi

# Check current session status
has_active_session=false
session_status=""

if [ -f "$WORK_LOG" ]; then
    if grep -q "status: in_progress" "$WORK_LOG" 2>/dev/null; then
        # Check if the session has expired
        timer_status=$(~/mybins/tmux/wisp-tmux.sh)
        if [[ "$timer_status" == *"Done"* ]]; then
            # Session expired, show as no active session
            has_active_session=false
        else
            has_active_session=true
            session_status="running"
        fi
    elif grep -q "status: paused" "$WORK_LOG" 2>/dev/null; then
        has_active_session=true
        session_status="paused"
    fi
fi

# Build and display menu based on current state
if [ "$has_active_session" = true ]; then
    if [ "$session_status" = "running" ]; then
        tmux display-menu -x C -y C -T " Wisp " \
            "Pause Session" p "run-shell 'wisp pause'" \
            "" \
            "Complete Session" c "run-shell 'wisp complete'" \
            "Cancel Session" x "run-shell 'wisp cancel'" \
            "" \
            "Show History" h "display-popup -x C -y C -w 80 -h 20 -E 'wisp log'" \
            "Show Stats" t "display-popup -x C -y C -w 60 -h 15 -E 'wisp stats'"
    elif [ "$session_status" = "paused" ]; then
        tmux display-menu -x C -y C -T " Wisp " \
            "Resume Session" r "run-shell 'wisp resume'" \
            "" \
            "Complete Session" c "run-shell 'wisp complete'" \
            "Cancel Session" x "run-shell 'wisp cancel'" \
            "" \
            "Show History" h "display-popup -x C -y C -w 80 -h 20 -E 'wisp log'" \
            "Show Stats" t "display-popup -x C -y C -w 60 -h 15 -E 'wisp stats'"
    fi
else
    tmux display-menu -x C -y C -T " Wisp " \
        "Start 25min Session" 1 "run-shell 'wisp start 25'" \
        "Start 45min Session" 2 "run-shell 'wisp start 45'" \
        "Start Custom Session" s "command-prompt -p 'Duration (minutes):' 'run-shell \"wisp start %1\"'" \
        "" \
        "Show History" h "display-popup -x C -y C -w 80 -h 20 -E 'wisp log'" \
        "Show Stats" t "display-popup -x C -y C -w 60 -h 15 -E 'wisp stats'"
fi
