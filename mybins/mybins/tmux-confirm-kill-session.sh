#!/bin/bash

# Use gum confirm to ask for confirmation
if gum confirm --no-show-help "Kill this session?"; then
    tmux kill-session
fi