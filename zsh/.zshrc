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
