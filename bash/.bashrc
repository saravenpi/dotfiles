# If not running interactively, don't do anything and return early
[[ $- == *i* ]] || return

# bash configuration
. ~/.bash_functions
. ~/.bash_variables
. ~/.bash_settings

# aliases
. ~/.bash_aliases
. ~/containers/.bash_aliases

# other programs
. ~/.bash_starship

welcome
