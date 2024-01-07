#!/bin/bash
workspace=10
kitty="kitty htop"
ntfy="firefox https://ntfy.sh/app"

i3-msg "workspace $workspace; exec $kitty"
i3-msg "workspace $workspace; exec $ntfy"
