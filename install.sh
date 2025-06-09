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
backupFile ".emacs"
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
backupProgram "ghostty"

echo "✅ Created a backup of your config files at: $backup_folder/"
unset backup_folder

# Clone the repo
echo "ℹ️ Cloning the dotfiles repo..."
git clone https://github.com/saravenpi/dotfiles $HOME/.dotfiles

# Install the config
echo "ℹ️ Installing config with stow"
cd $HOME/.dotfiles/
stow fonts
stow i3 dunst scripts picom polybar rofi
stow kitty tmux fish bash starship ghostty
stow nvim vim clang-format emacs
stow git lazygit kettle
stow mybins containers

# Ask to install additional programs
while true; do
  read -p "Do you want to install additional programs? (Y/n) " yn </dev/tty

  case $yn in
  [yY])
    echo "ok, we will proceed"
    break
    ;;
  [nN])
    echo "🎉 Dotfiles installed successfully! 🎉 (without additional programs)"
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

# Installing additional programs
echo "ℹ️ Installing additional programs"

# Install Bun
echo "ℹ️ Installing bun"
if [[ -d "$HOME/.bun" ]]; then
  echo "ℹ️ bun is already installed"
else
  echo "ℹ️ Installing bun"
  curl -fsSL https://bun.sh/install | bash
  if [[ $? -eq 0 ]]; then
    echo "✅ Installed bun successfully"
  else
    echo "❌ failed to install bun"
  fi
fi

# Install gitmoji-cli with bun
if which bun >/dev/null; then
  echo "ℹ️ Installing gitmoji-cli"
  echo "⚠️ sudo permissions needed to install gitmoji-cli globally"
  sudo bun i -g gitmoji-cli
  if which gitmoji >/dev/null; then
    echo "✅ Installed gitmoji-cli successfully"
  else
    echo "❌ failed to install gitmoji-cli"
  fi
else
  echo "❌ failed to install gitmoji-cli"
  echo "bun command is not available"
fi

# Install pokemon-colorscripts
echo "ℹ️ Installing pokemon-colorscripts"
git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git
cd pokemon-colorscripts
echo "⚠️ sudo permissions needed to install pokemon-colorscripts"
sudo ./install.sh
if which pokemon-colorscripts >/dev/null; then
  echo "✅ Installed pokemon-colorscripts successfully"
else
  echo "❌ failed to install pokemon-colorscripts"
fi
rm -rf pokemon-colorscripts

# Install starship prompt
echo "ℹ️ Installing starship prompt"
curl -sS https://starship.rs/install.sh | sh
echo "✅ Installed starship successfully"

# Install Tmux Plugin Manager (tpm)
echo "ℹ️ Installing tmp (tmux plugin manager)"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "✅ Installed tpm successfully"

# Optional: Install Nvim with ./nvim-install.sh script (prompt for yes/no)
chmod +x $HOME/.dotfiles/scripts/nvim-install.sh
if [[ -f $HOME/.dotfiles/scripts/nvim-install.sh ]]; then
  while true; do
    read -p "Do you want to install Neovim? (Y/n) " yn </dev/tty

    case $yn in
    [yY])
      echo "ok, we will proceed"
      $HOME/.dotfiles/nvim-install.sh
      break
      ;;
    [nN])
      echo "Skipping Neovim installation"
      break
      ;;
    *)
      if [[ $yn = "" ]]; then
        echo "ok, we will proceed"
        $HOME/.dotfiles/nvim-install.sh
        break
      else
        echo "invalid choice"
      fi
      ;;
    esac
  done
else
  echo "❌ nvim-install.sh script not found"
fi

echo "🎉 Dotfiles installed successfully! 🎉"
