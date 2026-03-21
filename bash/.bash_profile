# shellcheck shell=bash
export BASH_CONF="bash_profile"
export PATH="$HOME/.local/bin:$PATH"
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
[[ -s ~/.bashrc ]] && source ~/.bashrc
export BASH_SILENCE_DEPRECATION_WARNING=1
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash --shims)"
fi
