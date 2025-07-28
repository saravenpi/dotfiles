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
export PATH="$PATH:$HOME/.local/bin"
