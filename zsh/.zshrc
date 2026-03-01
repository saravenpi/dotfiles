[[ $- == *i* ]] || return

. ~/.prompt
. ~/.variables
. ~/.aliases
. ~/.functions
. ~/.zsh_settings
. ~/.zsh_zoxide

# bun completions
[ -s "/Users/fangafunk/.bun/_bun" ] && source "/Users/fangafunk/.bun/_bun"
