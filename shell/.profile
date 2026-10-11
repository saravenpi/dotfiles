export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if [ -z "$XDG_RUNTIME_DIR" ]; then
    if [ -d "/run/user/$(id -u)" ]; then
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    else
        export XDG_RUNTIME_DIR="/tmp/user-$(id -u)"
        mkdir -p -m 0700 "$XDG_RUNTIME_DIR"
    fi
fi

if [ -f "$HOME/.variables" ]; then
    . "$HOME/.variables"
fi

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty 2>/dev/null)" = "/dev/tty1" ]; then
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER_ALLOW_SOFTWARE=1
    exec sway
fi
