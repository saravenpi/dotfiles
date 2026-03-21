[[ $- == *i* ]] || return

[ -s "$HOME/.prompt" ] && . ~/.prompt
[ -s "$HOME/.variables" ] && . ~/.variables
[ -s "$HOME/.aliases" ] && . ~/.aliases
[ -s "$HOME/.functions" ] && . ~/.functions
[ -s "$HOME/.zsh_settings" ] && . ~/.zsh_settings

[ -s "$HOME/.fzf_theme" ] && source "$HOME/.fzf_theme"

_update_fzf_from_tmux() {
    if [ -n "$TMUX" ]; then
        local tmux_fzf=$(tmux show-environment -g FZF_DEFAULT_OPTS 2>/dev/null | cut -d'=' -f2-)
        if [ -n "$tmux_fzf" ] && [ "$tmux_fzf" != "$FZF_DEFAULT_OPTS" ]; then
            export FZF_DEFAULT_OPTS="$tmux_fzf"
        fi
    fi
}

if [ -n "$TMUX" ]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _update_fzf_from_tmux
fi

export PATH="$HOME/.local/bin:$PATH"

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh --no-cmd)"
fi
