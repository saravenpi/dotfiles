#!/bin/bash

while :; do
	id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
	name=$(xprop -id $id | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)

	# if no active window, then it's the desktop
	if [ "$name" = "" ]; then
		echo "Desktop"
		exit 0
	fi

	# split matching "-" and keep the last element which is the app name
	echo "$name" | awk -F- '{print $NF}'
done
