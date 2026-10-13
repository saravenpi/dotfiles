# shellcheck shell=bash disable=SC1091
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if [ -f "$HOME/.variables" ]; then
    . "$HOME/.variables"
fi

if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh --shims)"
fi

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty 2>/dev/null)" = "/dev/tty1" ]; then
    exec Hyprland
fi
