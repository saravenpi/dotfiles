export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if [ -f "$HOME/.variables" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.variables"
fi

# Sway is the Wayland session on Linux only; macOS has no /dev/tty1.
if [ "$(uname -s)" = "Linux" ] && [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] \
    && [ "$(tty 2>/dev/null)" = "/dev/tty1" ]; then
    export WLR_RENDERER=pixman
    export LIBGL_ALWAYS_SOFTWARE=1
    exec dbus-run-session sway
fi
