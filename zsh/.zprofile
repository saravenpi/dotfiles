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

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ] && [ -z "$SSH_CONNECTION" ]; then
    case "$(tty 2>/dev/null)" in
        /dev/tty*|/dev/vc/*|/dev/console|tty*)
            if command -v niri >/dev/null 2>&1; then
                export WLR_NO_HARDWARE_CURSORS=1
                export WLR_RENDERER_ALLOW_SOFTWARE=1

                if command -v dbus-run-session >/dev/null 2>&1 && [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
                    exec dbus-run-session niri --session
                else
                    exec niri --session
                fi
            fi
            ;;
    esac
fi
