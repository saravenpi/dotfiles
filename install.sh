#!/bin/bash

# Display the menu
echo "      ___           ___           ___           ___     "
echo "     /  /\         /  /\         /  /\         /  /\    "
echo "    /  /:/_       /  /::\       /  /::\       /  /::\   "
echo "   /  /:/ /\     /  /:/\:\     /  /:/\:\     /  /:/\:\  "
echo "  /  /:/ /::\   /  /:/~/::\   /  /:/~/:/    /  /:/~/::\ "
echo " /__/:/ /:/\:\ /__/:/ /:/\:\ /__/:/ /:/___ /__/:/ /:/\:\\"
echo " \  \:\/:/~/:/ \  \:\/:/__\/ \  \:\/:::::/ \  \:\/:/__\/"
echo "  \  \::/ /:/   \  \::/       \  \::/~~~~   \  \::/     "
echo "   \__\/ /:/     \  \:\        \  \:\        \  \:\     "
echo "     /__/:/       \  \:\        \  \:\        \  \:\    "
echo "     \__\/         \__\/         \__\/         \__\/    "
echo "                                                        "
echo "                                                        "
echo "                                                        "
echo "                             dotfiles made by @saravenpi"
echo "                                                        "
echo "                                                        "

# Prompt user for install
echo "This script will backup your current config and install the new one."
echo "Do you wish to proceed?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) make install; break;;
        No ) exit;;
    esac
done


# Check if git is installed
if ! command -v git &>/dev/null; then
    echo "The command git could not be found."
    echo "The installation process requires git to continue."
    echo "Please install git and try again."
    echo "Exiting..."
    exit 1
fi

# Check if stow is installed
if ! command -v stow &>/dev/null; then
	echo "The command stow could not be found."
	echo "The installation process requires GNU stow to continue."
	echo "Please install GNU stow and try again."
	echo "Exiting..."
	exit 1
fi

# Prepare the backup folder
backup_folder="$HOME/.config/config.old"
mkdir -p $backup_folder
mkdir -p "$backup_folder/.config/"

# Function to backup a file under the home folder
backupFile() {
	echo "📄 Backing up file: $1 to $backup_folder"
	if [[ -f "$HOME/$1" ]]; then
		mv $HOME/$1 $backup_folder
	fi
}

# Function to backup a folder under the home folder
backupFolder() {
	echo "📁 Backing up folder: $1 to $backup_folder"
	if [[ -d "$HOME/$1" ]]; then
		mv $HOME/$1 $backup_folder
	fi
}

# Function to backup a program config folder under the home folder
backupProgram() {
	echo "💿 Backing up program: $1 to $backup_folder/.config/"
	if [[ -d "$HOME/.config/$1" ]]; then
		mv $HOME/.config/$1 "$backup_folder/.config/"
	fi
}

echo "Creating a backup of your config files..."

# Backup files
backupFile ".bashrc"
backupFile ".bash_aliases"
backupFile ".bash_functions"

backupFile ".config/starship.toml"

backupFile ".tmux.conf"

backupFile ".clang-format"

backupFile ".gitconfig"

backupFile ".battery-warning.sh"
backupFile ".currentapp.sh"
backupFile ".desktop.sh"
backupFile ".menu.sh"
backupFile ".openchatgpt.sh"

# Backup folders
backupFolder "fonts"
backupFolder ".dotfiles"

# Backup program config folders
backupProgram "dunst"
backupProgram "fish"
backupProgram "gtk-3.0"
backupProgram "home-manager"
backupProgram "hyprland"
backupProgram "i3"
backupProgram "kettle"
backupProgram "kitty"
backupProgram "lazygit"
backupProgram "nixpkgs"
backupProgram "nvim"
backupProgram "picom"
backupProgram "polybar"
backupProgram "rofi"

echo "Created a backup of your config files at: $backup_folder/"
unset backup_folder

# Clone the repo
echo "Cloning the dotfiles repo..."
git clone git@github.com:saravenpi/dotfiles.git $HOME/.dotfiles


echo "Installing config with stow"
cd $HOME/dotfiles/
stow fonts

# config for X11
stow i3
stow dunst
stow gtk-3.0
stow scripts
stow picom
stow polybar
stow rofi

# config for wayland
stow hyprland

# config for terminal
stow kitty
stow tmux
stow fish
stow bash
stow starship

# config for editors
stow nvim
stow clang-format

# config for my boilerplates
stow kettle

# config for git
stow git
stow lazygit

# config for nix
stow home-manager
stow nixpkgs
