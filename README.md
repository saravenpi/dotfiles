# dotfiles

## Requirements for the config
- [stow](https://www.gnu.org/software/stow/)
- (the programs you want to be configured)

## How to install the config
You can use the installation script.
It will backup the common files between this config and yours.
Doing so, the conflicting config files from your config will not be lost.
The backup is saved under `~/.config/config.old/`
Paste this one line in your terminal:
```sh
curl -fsSL https://raw.githubusercontent.com/saravenpi/dotfiles/main/install.sh | bash
``` 
now the config should be up and running !
