!/bin/sh

# STOW THE NEW CONFIG
stow dunst
stow fish
stow fonts
stow home-manager
stow i3
stow kitty
stow nixpkgs
stow nvim
stow picom
stow polybar
stow rofi

# INSTALL VIM PLUGING MANAGER FOR NEOVIM
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
