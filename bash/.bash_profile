# shellcheck shell=bash disable=SC1090,SC1091
export BASH_CONF="bash_profile"
export PATH="$HOME/.local/bin:$PATH"

if [ -f "$HOME/.variables" ]; then
    . "$HOME/.variables"
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
    exec sway
fi
