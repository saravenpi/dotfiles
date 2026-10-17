# shellcheck shell=bash
[[ $- == *i* ]] || return

for file in \
    "$HOME/.prompt" \
    "$HOME/.variables" \
    "$HOME/.functions" \
    "$HOME/.bash_settings" \
    "$HOME/.bash_interactive" \
    "$HOME/.aliases"
do
    [ -s "$file" ] && . "$file"
done


# Added by Antigravity CLI installer
export PATH="/home/sara/.local/bin:$PATH"
