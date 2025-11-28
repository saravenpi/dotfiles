#!/usr/bin/env bash

dir="$HOME/.config/polybar"

killall -q polybar
killall -q polybar
killall -q polybar
killall -q polybar
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar --reload -c "$dir/forest/config.ini" main & sleep 1
polybar --reload -c "$dir/bottom/config.ini" bottom & sleep 1
