#!/bin/bash

# Display the welcome message
echo " _                        "
echo " \`*-.                    "
echo "  )  _\`-.                 "
echo " .  : \`. .                "
echo " : _   '  \               "
echo " ; *\` _.   \`*-._          "
echo " \`-.-\'          \`-.       "
echo "   ;       \`       \`.     "
echo "   :.       .        \    "
echo "   . \  .   :   .-'   .   "
echo "   '  \`+.;  ;  '      :   "
echo "   :  '  |    ;       ;-. "
echo "   ; '   : :\`-:     _.\`* ;"
echo ".*' /  .*' ; .*\`- +'  \`*' "
echo "\`*-*   \`*-*  \`*-*'"
echo "                          "
echo "dotfiles made by @saravenpi"
echo "                          "

# Prompt user for install
echo "⚠️ This script will backup your current config and install the new one. ⚠️"
echo ""

while true; do
    read -p "Do you want to proceed? (Y/n) " yn </dev/tty

    case $yn in
        [yY])
            echo "ok, we will proceed"
            break
            ;;
        [nN])
            echo "exiting..."
            exit
            ;;
        *)
            if [[ $yn = "" ]]; then
                echo "ok, we will proceed"
                break
            else
                echo "invalid choice"
            fi
            ;;
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
rm -rf $backup_folder
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

echo "ℹ️ Creating a backup of your config files..."

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

echo "✅ Created a backup of your config files at: $backup_folder/"
unset backup_folder

# Clone the repo
echo "ℹ️ Cloning the dotfiles repo..."
git clone git@github.com:saravenpi/dotfiles.git $HOME/.dotfiles

# Install the config
echo "ℹ️ Installing config with stow"
cd $HOME/.dotfiles/
stow fonts
stow i3 dunst gtk-3.0 scripts picom polybar rofi
stow hyprland
stow kitty tmux fish bash starship
stow nvim clang-format
stow kettle
stow git lazygit

# Installing additional programs
echo "ℹ️ Installing additional programs"
if which node > /dev/null
then
    echo "ℹ️ Installing gitmoji-cli"
    echo "⚠️ sudo permissions needed to install gitmoji-cli globally"
    sudo npm i -g gitmoji-cli
    echo "✅ Installed gitmoji-cli successfully"
else
    echo "❌ failed to install gitmoji-cli"
    echo "npm command is not available"
fi

echo "ℹ️ Installing neovim appimage"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
echo "⚠️ sudo permissions needed to move neovim.appimage to /usr/bin/"
sudo mv nvim.appimage /usr/bin/nvim
if test -f /usr/bin/nvim ; then
    echo "✅ Installed neovim successfully"
else
    echo "❌ failed to install neovim"
fi

echo "ℹ️ Installing rip"
curl -LO https://github.com/nivekuil/rip/releases/download/0.12.0/rip
chmod +x rip
echo "⚠️ sudo permissions needed to move rip to /usr/bin/"
sudo mv rip /usr/bin/rip
if test -f /usr/bin/rip ; then
    echo "✅ Installed rip successfully"
else
    echo "❌ failed to install rip"
fi

echo "ℹ️ Installing pokemon-colorscripts"
git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git
cd pokemon-colorscripts
echo "⚠️ sudo permissions needed to install pokemon-colorscripts"
sudo ./install.sh
echo "✅ Installed pokemon-colorscripts successfully"

echo "🎉 Dotfiles installed successfully! 🎉"
