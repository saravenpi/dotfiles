# If not running interactively, don't do anything and return early
[[ $- == *i* ]] || return

# # aliases
. ~/.bash_aliases
. ~/containers/.bash_aliases

# bash configuration
. ~/.bash_functions
. ~/.bash_variables
. ~/.zsh_settings
. ~/.zsh_zoxide

# Welcome
welcome


# Added by Windsurf
export PATH="/Users/yannthevenin/.codeium/windsurf/bin:$PATH"

# bun completions
[ -s "/Users/yannthevenin/.bun/_bun" ] && source "/Users/yannthevenin/.bun/_bun"
export PATH="$HOME/.local/bin:$PATH"
