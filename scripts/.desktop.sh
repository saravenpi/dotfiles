#!/bin/bash
monitor_workspace=10
terminal_workspace=1
browser_workspace=2

kitty="kitty htop"
ntfy="firefox https://ntfy.sh/app"
terminal="kitty tmux"

i3-msg "workspace $monitor_workspace; exec $kitty"
i3-msg "workspace $monitor_workspace; exec $ntfy"
i3-msg "workspace $terminal_workspace; exec $terminal"
i3-msg "workspace $browser_workspace; exec firefox"
