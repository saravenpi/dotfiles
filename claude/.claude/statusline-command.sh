#!/bin/bash

# Read Claude Code session info
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
output_style=$(echo "$input" | jq -r '.output_style.name')

# Directory display with truncation (similar to your starship config)
dir_display() {
    local dir="$1"
    local home_replaced="${dir/#$HOME/~}"
    
    # Split path into components
    IFS='/' read -ra parts <<< "$home_replaced"
    local num_parts=${#parts[@]}
    
    # If more than 8 parts (matching your truncation_length), truncate
    if [ $num_parts -gt 8 ]; then
        local start_parts=("${parts[@]:0:2}")  # Keep first 2 parts
        local end_parts=("${parts[@]: -6}")    # Keep last 6 parts
        printf "%s/📁/%s" "$(IFS='/'; echo "${start_parts[*]}")" "$(IFS='/'; echo "${end_parts[*]}")"
    else
        echo "$home_replaced"
    fi
}

# Git branch info
git_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
        local status=""
        
        # Check for uncommitted changes
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            status="*"
        fi
        
        # Check for untracked files
        if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
            status="${status}+"
        fi
        
        if [ -n "$branch" ]; then
            printf " on \033[35m%s%s\033[0m" "$branch" "$status"
        fi
    fi
}

# Battery info (macOS specific)
battery_info() {
    if command -v pmset >/dev/null 2>&1; then
        local battery_info=$(pmset -g batt | grep -E "([0-9]+%)" 2>/dev/null)
        if [ -n "$battery_info" ]; then
            local percentage=$(echo "$battery_info" | grep -o '[0-9]*%' | head -1)
            local charging_status=$(echo "$battery_info" | grep -o 'charging\|discharging\|charged' | head -1)
            
            case "$charging_status" in
                "charging") printf " ⚡️%s" "$percentage" ;;
                "charged") printf " 🔋%s" "$percentage" ;;
                "discharging") 
                    local num=${percentage%\%}
                    if [ "$num" -lt 20 ]; then
                        printf " 💀%s" "$percentage"
                    else
                        printf " 🔋%s" "$percentage"
                    fi
                    ;;
            esac
        fi
    fi
}

# Main status line
printf "\033[2m%s\033[0m \033[36m%s\033[0m\033[33m%s\033[0m%s \033[2m[%s]\033[0m" \
    "$model" \
    "$(dir_display "$current_dir")" \
    "$(git_info)" \
    "$(battery_info)" \
    "$output_style"