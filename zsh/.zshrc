[[ $- == *i* ]] || return

export PATH="$HOME/Code/Facile/kori.nvim/bin:$PATH"

for file in \
    "$HOME/.prompt" \
    "$HOME/.variables" \
    "$HOME/.functions" \
    "$HOME/.zsh_settings" \
    "$HOME/.zsh_interactive" \
    "$HOME/.aliases"
do
    [ -s "$file" ] && . "$file"
done

command -v pokeget >/dev/null 2>&1 && pokeget random --hide-name
