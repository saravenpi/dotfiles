# If not running interactively, don't do anything and return early
[[ $- == *i* ]] || return

if [ -f ~/.variables ]; then
    . ~/.variables
fi

# # aliases
. ~/.aliases
. ~/containers/.bash_aliases

# bash configuration
. ~/.functions
. ~/.zsh_settings
. ~/.zsh_zoxide

# Welcome
welcome
export PATH="$HOME/.local/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/yannthevenin/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
[[ -f "$HOME/.claude/hooks.sh" ]] && source "$HOME/.claude/hooks.sh"
