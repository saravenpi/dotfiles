#!/bin/sh

# BACKUP THE OLD CONFIG
mkdir -p ~/.old.config/
cp -r ~/.config/dunst/ ~/.old.config/
cp -r ~/.config/fish/ ~/.old.config/
cp -r ~/.fonts/ ~/.old.config/
cp -r ~/.config/hypr/ ~/.old.config/
cp -r ~/.config/i3/ ~/.old.config/
cp -r ~/.config/kitty/ ~/.old.config/
cp -r ~/.config/nvim/ ~/.old.config/
cp -r ~/.config/polybar/ ~/.old.config/
cp -r ~/.config/rofi/ ~/.old.config/
cp -r ~/.config/picom/ ~/.old.config/
cp ~/.config/starship.toml ~/.old.config/
cp ~/.tmux.conf ~/.old.config/
cp -r ~/.config/hypr/ ~/.old.config/

# UNLINK THE OLD CONFIG (IN CASE IT IS ALREADY USING THE CONFIG)
stow --delete dunst
stow --delete fish
stow --delete fonts
stow --delete hypr
stow --delete i3
stow --delete kitty
stow --delete nvim
stow --delete picom
stow --delete polybar
stow --delete qutebrowser
stow --delete rofi
stow --delete starship
stow --delete tmux
stow --delete waybar

echo "The old config files for the following packages:"
echo "neovim, dunst, fish,i3, kitty, polybar, rofi, starship, hypr, waybar (if installed)"
echo "were moved to ~/.config/.old.config/"

# STOW THE NEW CONFIG
stow dunst
stow fish
stow fonts
stow hypr
stow i3
stow kitty
stow nvim
stow picom
stow polybar
stow qutebrowser
stow rofi
stow starship
stow tmux
stow waybar
