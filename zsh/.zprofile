export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh --shims)"
fi

if [ -z "${XDG_RUNTIME_DIR:-}" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    if [ ! -d "$XDG_RUNTIME_DIR" ]; then
        export XDG_RUNTIME_DIR="/tmp/user-$(id -u)"
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 0700 "$XDG_RUNTIME_DIR"
    fi
fi

if [ -S /run/seatd.sock ] && [ -z "${LIBSEAT_BACKEND:-}" ]; then
    export LIBSEAT_BACKEND=seatd
fi

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    case "$(tty 2>/dev/null)" in
        /dev/tty1|/dev/vc/1)
            if [ -z "$NO_NIRI" ] && command -v niri >/dev/null 2>&1; then
                export WLR_NO_HARDWARE_CURSORS=1
                export WLR_RENDERER_ALLOW_SOFTWARE=1
                export NO_AT_BRIDGE=1
                export GTK_USE_PORTAL=0

                cmd="niri --session"
                if command -v dbus-run-session >/dev/null 2>&1 && [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
                    cmd="dbus-run-session $cmd"
                fi
                if command -v seatd-launch >/dev/null 2>&1; then
                    seatd-launch -- sh -c "$cmd"
                else
                    eval "$cmd"
                fi
            fi
            ;;
    esac
fi
