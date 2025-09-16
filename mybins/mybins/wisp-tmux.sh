#!/usr/bin/env bash

# WISP Tmux Status Display
# Shows current work session status in tmux status bar

WORK_LOG="$HOME/.wisp.yml"

# Get current session info
get_current_session() {
    if [ ! -f "$WORK_LOG" ]; then
        echo ""
        return
    fi

    # Find the last active session (in_progress or paused)
    local session_found=""
    local session_info=""
    local start_time=""
    local planned_minutes=""
    local start_timestamp=""
    local session_status=""
    local pause_timestamp=""
    local total_pause_time=0

    # Read through the file to find the last active session
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*date: ]]; then
            # Start of new session
            session_info=""
            start_time=""
            planned_minutes=""
            start_timestamp=""
            session_status=""
            pause_timestamp=""
            total_pause_time=0
        elif [[ "$line" =~ ^[[:space:]]*start_time:[[:space:]]*(.+) ]]; then
            start_time="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^[[:space:]]*start_timestamp:[[:space:]]*([0-9]+) ]]; then
            start_timestamp="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^[[:space:]]*planned_minutes:[[:space:]]*([0-9]+) ]]; then
            planned_minutes="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ pause_timestamp:[[:space:]]*([0-9]+) ]]; then
            pause_timestamp="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^[[:space:]]*total_pause_time:[[:space:]]*([0-9]+) ]]; then
            total_pause_time="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^[[:space:]]*status:[[:space:]]*in_progress ]]; then
            session_status="in_progress"
            session_found="found"
            # Don't set session_info yet, keep reading for more fields
        elif [[ "$line" =~ ^[[:space:]]*status:[[:space:]]*paused ]]; then
            session_status="paused"
            session_found="found"
            # Don't set session_info yet, keep reading for more fields
        fi
    done < "$WORK_LOG"

    # Build session_info after reading all fields
    if [ "$session_found" = "found" ]; then
        session_info="$start_time|$planned_minutes|$start_timestamp|$session_status|$pause_timestamp|$total_pause_time"
        echo "$session_info"
    else
        echo ""
    fi
}

# Format time remaining with live seconds
format_time_remaining() {
    local start_timestamp="$1"
    local planned_minutes="$2"
    local status="$3"
    local pause_timestamp="$4"
    local total_pause_time="${5:-0}"
    local current_timestamp=$(date +%s)

    local elapsed_seconds
    if [ "$status" = "paused" ] && [ -n "$pause_timestamp" ]; then
        # For paused sessions, freeze time at pause point
        # Don't use current_timestamp, use pause_timestamp
        elapsed_seconds=$((pause_timestamp - start_timestamp))
    else
        # For running sessions, calculate current elapsed time
        elapsed_seconds=$((current_timestamp - start_timestamp - total_pause_time))
    fi

    local planned_seconds=$((planned_minutes * 60))
    local remaining_seconds=$((planned_seconds - elapsed_seconds))

    if [ $remaining_seconds -le 0 ]; then
        echo " Session Done"
        return
    fi

    local remaining_minutes=$((remaining_seconds / 60))
    local remaining_secs=$((remaining_seconds % 60))

    # Show appropriate icon based on status
    if [ "$status" = "paused" ]; then
        printf " %02d:%02d" "$remaining_minutes" "$remaining_secs"
    else
        printf " %02d:%02d" "$remaining_minutes" "$remaining_secs"
    fi
}

# Main function
main() {
    local session_info=$(get_current_session)

    if [ -z "$session_info" ]; then
        echo "󰒲 Inactive"
        return
    fi

    # Parse session info
    IFS='|' read -r start_time planned_minutes start_timestamp status pause_timestamp total_pause_time <<< "$session_info"

    # Debug output (comment out in production)
    # echo "DEBUG: session_info=$session_info" >&2
    # echo "DEBUG: status=$status, pause_ts=$pause_timestamp" >&2

    if [ -n "$start_timestamp" ] && [ -n "$planned_minutes" ] && [ -n "$status" ]; then
        format_time_remaining "$start_timestamp" "$planned_minutes" "$status" "$pause_timestamp" "$total_pause_time"
    else
        echo " Working"
    fi
}

main "$@"
