[[ $- == *i* ]] || return

# bash configuration
[ -s "$HOME/.functions" ] && . ~/.functions
[ -s "$HOME/.variables" ] && . ~/.variables
[ -s "$HOME/.bash_settings" ] && . ~/.bash_settings

# aliases
[ -s "$HOME/.aliases" ] && . ~/.aliases
[ -s "$HOME/containers/.bash_aliases" ] && . "$HOME/containers/.bash_aliases"

export PATH="$PATH:$HOME/.local/bin"

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi

# other programs
[ -s "$HOME/.bash_starship" ] && . ~/.bash_starship

command -v welcome >/dev/null 2>&1 && welcome

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --no-cmd)"
fi
