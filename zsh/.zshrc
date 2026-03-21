[[ $- == *i* ]] || return

for file in \
    "$HOME/.prompt" \
    "$HOME/.variables" \
    "$HOME/.aliases" \
    "$HOME/.functions" \
    "$HOME/.zsh_settings" \
    "$HOME/.zsh_interactive"
do
    [ -s "$file" ] && . "$file"
done
