!/bin/sh

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
