# dotfiles

## ⚠️ Requirements
- [stow](https://www.gnu.org/software/stow/)
- the programs you want to be configured

## How to install the config
Paste this one line in your terminal:
```sh
curl -fsSL https://saravenpi.me/install.sh | bash
``` 
🎉 ! Now the config should be up and running !

## How the installation script behaves
It will backup the common files between this config and yours.

Doing so, the conflicting config files from your config will not be lost.

The backup is saved under `~/.config/config.old/`

Then it uses [GNU stow](https://www.gnu.org/software/stow/) to install the config files.

It creates symlinks in your system in the correct locations from the repo.
