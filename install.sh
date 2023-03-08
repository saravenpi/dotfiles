#!/bin/sh

# BACKUP THE OLD CONFIG
mkdir -p ~/.old.config/
cp -r ~/.config/nvim/ ~/.old.config/
cp -r ~/.config/dunst/ ~/.old.config/
cp -r ~/.config/fish/ ~/.old.config/
cp -r ~/.fonts/ ~/.old.config/
cp -r ~/.config/i3/ ~/.old.config/
cp -r ~/.config/kitty/ ~/.old.config/
cp -r ~/.config/polybar/ ~/.old.config/
cp -r ~/.config/rofi/ ~/.old.config/
cp -r ~/.config/picom/ ~/.old.config/
cp ~/.config/starship.toml ~/.old.config/
cp ~/.tmux.conf ~/.old.config/

# UNLINK THE OLD CONFIG (IN CASE IT IS ALREADY USING THE CONFIG)
stow --delete nvim
stow --delete dunst
stow --delete fish
stow --delete fonts
stow --delete i3
stow --delete kitty
stow --delete polybar
stow --delete rofi
stow --delete picom
stow --delete starship
stow --delete tmux

echo "The old config files for the following packages:"
echo "neovim, dunst, fish,i3, kitty, polybar, rofi, starship (if installed)"
echo "were moved to ~/.config/.old.config/"

# STOW THE NEW CONFIG
stow nvim
stow dunst
stow fish
stow fonts
stow i3
stow kitty
stow polybar
stow rofi
stow starship
stow picom
stow tmux
