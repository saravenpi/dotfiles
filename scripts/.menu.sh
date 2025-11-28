#!/bin/bash

# Define your menu options and corresponding scripts
declare -A menu=(
	["ChatGPT"]="$HOME/.openchatgpt.sh"
	["shutdown"]="systemctl poweroff"
	["reboot"]="systemctl reboot"
	["lock"]="i3lock"
	["desktop reload"]="$HOME/.desktop.sh"
)

# Create a newline-separated string of keys (menu options)
options=$(printf "%s\n" "${!menu[@]}")

# Launch Rofi with options, capturing the user's selection
selected=$(echo -e "$options" | rofi -dmenu -p "Choose an option:")

# Exit if nothing was selected (e.g., user pressed Escape)
[[ -z $selected ]] && exit

# Execute the script associated with the selection
"${menu[$selected]}"
