# If not running interactively, don't do anything and return early
[[ $- == *i* ]] || return

# # aliases
. ~/.bash_aliases
. ~/containers/.bash_aliases

# bash configuration
. ~/.bash_functions
# . ~/.bash_variables
. ~/.zsh_settings
. ~/.zsh_zoxide

# Welcome
welcome
