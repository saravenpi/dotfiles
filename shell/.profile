export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if [ -z "$XDG_RUNTIME_DIR" ]; then
    u_id="$(id -u)"
    if [ -d "/run/user/$u_id" ]; then
        XDG_RUNTIME_DIR="/run/user/$u_id"
    else
        XDG_RUNTIME_DIR="/tmp/user-$u_id"
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 0700 "$XDG_RUNTIME_DIR"
    fi
    export XDG_RUNTIME_DIR
fi

if [ -f "$HOME/.variables" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.variables"
fi

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty 2>/dev/null)" = "/dev/tty1" ]; then
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER_ALLOW_SOFTWARE=1
    exec sway
fi
