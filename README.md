# dotfiles

## ⚠️ Requirements

### Core Dependencies (Required)
- **git** - Version control system
  - macOS: `brew install git` or [download](https://git-scm.com/downloads)
  - Linux: `apt/yum/pacman install git`
- **[GNU Stow](https://www.gnu.org/software/stow/)** - Symlink farm manager
  - macOS: `brew install stow`
  - Linux: `apt/yum/pacman install stow`

### Optional Programs
Install these to use their configurations:

#### Shell & Terminal
- **[Starship](https://starship.rs/)** - Cross-shell prompt
  - Install: `curl -sS https://starship.rs/install.sh | sh`
- **[Fish](https://fishshell.com/)** - Friendly interactive shell
  - macOS: `brew install fish`
  - Linux: Package manager or [download](https://fishshell.com/#get_fish_linux)
- **[Tmux](https://github.com/tmux/tmux)** - Terminal multiplexer
  - macOS: `brew install tmux`
  - Linux: Package manager
- **[TPM](https://github.com/tmux-plugins/tpm)** - Tmux Plugin Manager
  - Install: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- **[Kitty](https://sw.kovidgoyal.net/kitty/)** - GPU-based terminal
  - macOS: `brew install --cask kitty`
  - Linux: [Download](https://sw.kovidgoyal.net/kitty/binary/)
- **[Ghostty](https://ghostty.org/)** - Modern terminal emulator
  - See [official docs](https://ghostty.org/docs/install)

#### Development Tools
- **[Neovim](https://neovim.io/)** - Hyperextensible Vim-based text editor
  - Via [bob](https://github.com/MordechaiHadad/bob): `cargo install --git https://github.com/MordechaiHadad/bob.git`
  - Then: `bob install nightly && bob use nightly`
- **[Lazygit](https://github.com/jesseduffield/lazygit)** - Terminal UI for git
  - macOS: `brew install lazygit`
  - Linux: See [installation guide](https://github.com/jesseduffield/lazygit#installation)
- **[Bun](https://bun.sh/)** - Fast JavaScript runtime
  - Install: `curl -fsSL https://bun.sh/install | bash`

#### Window Management
- **[i3](https://i3wm.org/)** - Tiling window manager (Linux)
  - Linux: Package manager
- **[Aerospace](https://github.com/nikitabobko/AeroSpace)** - Tiling window manager (macOS)
  - macOS: `brew install --cask nikitabobko/tap/aerospace`
- **[Picom](https://github.com/yshui/picom)** - Compositor for X11
  - Linux: Package manager
- **[Polybar](https://github.com/polybar/polybar)** - Status bar
  - Linux: Package manager or [build from source](https://github.com/polybar/polybar/wiki/Compiling)
- **[Rofi](https://github.com/davatorium/rofi)** - Application launcher
  - Linux: Package manager
- **[Dunst](https://dunst-project.org/)** - Notification daemon
  - Linux: Package manager

#### Fun Extras
- **[pokemon-colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts)** - Display Pokémon in terminal
  - Install: Clone and run `./install.sh`
- **[gitmoji-cli](https://github.com/carloscuesta/gitmoji-cli)** - Emoji commit messages
  - Install: `npm i -g gitmoji-cli` or `bun install -g gitmoji-cli`

## How to install the config
Paste this one line in your terminal:
```sh
curl -fsSL https://raw.githubusercontent.com/saravenpi/dotfiles/main/install.sh | bash
``` 
🎉 ! Now the config should be up and running !

## How the installation script behaves
It will backup the common files between this config and yours.

Doing so, the conflicting config files from your config will not be lost.

The backup is saved under `~/.config/config.old/`

Then it uses [GNU stow](https://www.gnu.org/software/stow/) to install the config files.

It creates symlinks in your system in the correct locations from the repo.
