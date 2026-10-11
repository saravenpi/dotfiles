# shellcheck shell=bash
export BASH_CONF="bash_profile"
export PATH="$HOME/.local/bin:$PATH"

if [ -z "$XDG_RUNTIME_DIR" ]; then
    if [ -d "/run/user/$(id -u)" ]; then
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    else
        export XDG_RUNTIME_DIR="/tmp/user-$(id -u)"
        mkdir -p -m 0700 "$XDG_RUNTIME_DIR"
    fi
fi

[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
[[ -s ~/.bashrc ]] && source ~/.bashrc
export BASH_SILENCE_DEPRECATION_WARNING=1
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash --shims)"
fi

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty 2>/dev/null)" = "/dev/tty1" ]; then
    export WLR_NO_HARDWARE_CURSORS=1
    export WLR_RENDERER_ALLOW_SOFTWARE=1
    exec sway
fi
