#!/bin/bash

# check the battery level
charge_level="$(cat /sys/class/power_supply/BAT1/capacity)"

# check if the laptop is plugged in
ac_adapter="$(cat /sys/class/power_supply/ACAD/online)"

if [[ ac_adapter -eq 0 ]]; then
	echo "Not Plugged"
	if [[ charge_level < 20 ]]; then
		echo "You should plug in your laptop" $charge_level
	else
		echo "You're good to go" $charge_level
	fi
else
	echo "Plugged"
fi
