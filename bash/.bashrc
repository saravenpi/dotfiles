# shellcheck shell=bash
[[ $- == *i* ]] || return

for file in \
    "$HOME/.variables" \
    "$HOME/.aliases" \
    "$HOME/.functions" \
    "$HOME/.bash_settings" \
    "$HOME/.bash_interactive"
do
    [ -s "$file" ] && . "$file"
done
