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
4. Bootstraps [mise](https://mise.jdx.dev/) if needed
5. Installs global CLI tools from `~/.config/mise/config.toml`
6. Installs [TPM](https://github.com/tmux-plugins/tpm) and syncs tmux plugins
7. Installs [bob](https://github.com/MordechaiHadad/bob) and switches Neovim to `nightly`
8. Ensures `vhs` runtime dependencies are available when possible

## Tooling

- Runtime and CLI tools: `mise`
- Neovim version management: `bob`
- Shells: `zsh`, `bash`
- Terminal/editor setup: `kitty`, `tmux`, `nvim`
- Tmux plugins: `tpm`

## Notes

- Some configs are Linux-specific (`i3`, `polybar`, `rofi`, `picom`, `dunst`)
- Some configs are macOS-specific (`aerospace`)
- Repo-local `mise.toml` is only for dotfiles tasks; system tools live in `mise/.config/mise/config.toml`
- `vhs` also needs `ttyd` and `ffmpeg`; the installer handles this where possible and warns otherwise
