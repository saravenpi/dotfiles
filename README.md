# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Requirements

- `git`
- `stow`
- `curl`

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/saravenpi/dotfiles/main/install.sh | bash
```

## What The Installer Does

1. Backs up conflicting files to `~/.config/config.old.<timestamp>/`
2. Clones the repo to `~/.dotfiles`
3. Stows the config into `$HOME`
4. Installs [TPM](https://github.com/tmux-plugins/tpm) and syncs tmux plugins

## Notes

- Some configs are Linux-specific (`rofi`)