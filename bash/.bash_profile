export BASH_CONF="bash_profile"
[[ -s ~/.bashrc ]] && source ~/.bashrc
[[ -s /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="/opt/homebrew/opt/ruby@2.7/bin:$PATH"
eval "$(fzf --bash)"
. "$HOME/.cargo/env"
