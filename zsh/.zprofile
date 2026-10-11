export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi

if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh --shims)"
fi

if [ -e /sys/class/dmi/id/product_name ]; then
    case "$(cat /sys/class/dmi/id/product_name 2>/dev/null)" in
        *QEMU*|*VirtualBox*|*VMware*|*KVM*|*Bochs*)
            export WLR_NO_HARDWARE_CURSORS=1
            export WLR_RENDERER_ALLOW_SOFTWARE=1
            ;;
    esac
fi

if [ -S /run/seatd.sock ] && [ -z "${LIBSEAT_BACKEND:-}" ]; then
    export LIBSEAT_BACKEND=seatd
fi

if [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ] && [ -z "${SSH_CLIENT:-}" ] && [ -z "${SSH_TTY:-}" ] && [ -z "${SSH_CONNECTION:-}" ]; then
    is_tty1=0
    case "$(tty 2>/dev/null)" in
        /dev/tty1|/dev/vc/1|tty1)
            is_tty1=1
            ;;
    esac
    if [ "${XDG_VTNR:-}" = "1" ]; then
        is_tty1=1
    fi

    if [ "$is_tty1" -eq 1 ] && command -v niri >/dev/null 2>&1; then
        export XDG_CURRENT_DESKTOP=niri
        export XDG_SESSION_DESKTOP=niri
        export XDG_SESSION_TYPE=wayland
        export MOZ_ENABLE_WAYLAND=1
        export QT_QPA_PLATFORM="wayland;xcb"
        export GDK_BACKEND="wayland,x11"
        export ELECTRON_OZONE_PLATFORM_HINT="auto"
        export SDL_VIDEODRIVER="wayland"
        export _JAVA_AWT_WM_NONREPARENTING=1

        if [ -d /run/systemd/system ] && command -v niri-session >/dev/null 2>&1; then
            exec niri-session
        elif command -v dbus-run-session >/dev/null 2>&1 && [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
            exec dbus-run-session niri --session
        else
            exec niri --session
        fi
    fi
fi
