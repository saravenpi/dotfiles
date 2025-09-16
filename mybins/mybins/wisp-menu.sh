
#!/usr/bin/env bash

WORK_LOG="$HOME/.wisp.yml"

if [ -z "$TMUX" ]; then
    echo "Error: This menu must be run from within tmux"
    exit 1
fi

has_active_session=false
session_status=""

if [ -f "$WORK_LOG" ]; then
    if grep -q "status: in_progress" "$WORK_LOG" 2>/dev/null; then
        timer_status=$(~/mybins/wisp-format default)
        if [[ "$timer_status" == *"Inactive"* ]]; then
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

if [ "$has_active_session" = true ]; then
    if [ "$session_status" = "running" ]; then
        tmux display-menu -x C -y C -T " Wisp " \
            "Pause Session" p "run-shell '~/mybins/wisp pause'" \
            "" \
            "Stop Session" s "run-shell '~/mybins/wisp stop'" \
            "" \
            "Show History" h "display-popup -x C -y C -w 80 -h 20 -E '~/mybins/wisp-history-viewer.sh'" \
            "Show Stats" t "display-popup -x C -y C -w 60 -h 15 -E '~/mybins/wisp-stats-viewer.sh'"
    elif [ "$session_status" = "paused" ]; then
        tmux display-menu -x C -y C -T " Wisp " \
            "Resume Session" r "run-shell '~/mybins/wisp resume'" \
            "" \
            "Stop Session" s "run-shell '~/mybins/wisp stop'" \
            "" \
            "Show History" h "display-popup -x C -y C -w 80 -h 20 -E '~/mybins/wisp-history-viewer.sh'" \
            "Show Stats" t "display-popup -x C -y C -w 60 -h 15 -E '~/mybins/wisp-stats-viewer.sh'"
    fi
else
    tmux display-menu -x C -y C -T " Wisp " \
        "Start 25min Session" 1 "run-shell '~/mybins/wisp start 25'" \
        "Start 45min Session" 2 "run-shell '~/mybins/wisp start 45'" \
        "Start Custom Session" s "command-prompt -p 'Duration (minutes):' 'run-shell \"~/mybins/wisp start %1\"'" \
        "" \
        "Show History" h "display-popup -x C -y C -w 80 -h 20 -E '~/mybins/wisp-history-viewer.sh'" \
        "Show Stats" t "display-popup -x C -y C -w 60 -h 15 -E '~/mybins/wisp-stats-viewer.sh'"
fi
