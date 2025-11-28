[[ $- == *i* ]] || return

# bash configuration
. ~/.functions
. ~/.variables
. ~/.bash_settings

# aliases
. ~/.aliases
. ~/containers/.bash_aliases

# other programs
. ~/.bash_starship

welcome
export PATH="$PATH:$HOME/.local/bin"
