source ~/.config/fish/config_quick_edit.fish
source ~/.config/fish/aliases.fish
source ~/.config/fish/functions.fish
source ~/.config/fish/fzf_theme.fish
source ~/.config/fish/variables.fish
source ~/.config/fish/path.fish
source ~/.config/fish/ghcup.fish


set fish_greeting ""
starship init fish | source
zoxide init fish | source
pokemon-colorscripts -r
