export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if [ -f "$HOME/.variables" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.variables"
fi

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty 2>/dev/null)" = "/dev/tty1" ]; then
    exec Hyprland
fi
