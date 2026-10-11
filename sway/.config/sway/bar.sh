#!/bin/sh
if command -v waybar >/dev/null 2>&1; then
    exec waybar "$@"
fi
exec swaybar "$@"
