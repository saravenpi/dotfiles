# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2026-10-11

### Added

- `tido update`: re-runs `install.sh` from anywhere — pulls the checkout, re-links every package and installs the mise tools.

### Changed

- tmux configuration split into modular files: `tmux.conf` now only sources `options.conf`, `keybindings.conf`, `status.conf` and `plugins.conf` from `~/.config/tmux/`.
- tmux config entry point moved from `~/.tmux.conf` to `~/.config/tmux/tmux.conf`; the reload binding, `treload` and `ctmux` aliases follow it, and `set-clipboard` is enabled.
- Vendored tmux plugins trimmed to their runtime files: upstream CI, Vagrant, video and changelog leftovers dropped from `tmux-yank`, unused `go.mod`/`go.sum`/`filet.yml` from `tmux-agent-sidebar`.

### Removed

- `.tmux.conf` from the installer's backup list.

## [0.3.0] - 2026-10-11

### Added

- Vendored tmux plugins: `tmux-yank`, `sertren`, and `tmux-agent-sidebar` are now versioned in `~/.config/tmux/plugins` and loaded directly without TPM.
- `facile` package: versioned `~/.facile.yml` tool sources.
- `bulle` package: versioned `~/.bulle.yml`, agent profiles (`free`, `lerouteur`, `orange`), and automated jobs.

### Changed

- `tido`: displays usage help when invoked without arguments; accurately lists and reports all up-to-date paths in `list` dry-run mode.

### Removed

- TPM: dropped TPM installation and plugin sync from `install.sh` and `~/.tmux.conf`.
- `bob`: dropped Neovim version manager in favor of native system package managers (`apk`, `apt`).
- `bubble.nvim` plugin: removed from Neovim configuration.

## [0.2.0] - 2026-09-30

### Added

- Custom shell prompt: zsh loads `~/.prompt` (now versioned in the `zsh`
  package), bash builds the same prompt inline in `~/.bash_interactive`.

### Removed

- Starship: the `starship` package, `~/.bash_starship`, the mise tool entry and
  the installer fallback.

## [0.1.0] - 2026-09-30

Initial tagged release.

### Added

- Installer that links every dotfiles package into `$HOME` with `tido`, a
  dependency-free replacement for GNU Stow, backing up conflicting files
  instead of deleting them.
- mise management: the installer installs mise and every tool declared in
  `~/.config/mise/config.toml`, with the language runtimes pinned to exact
  versions.
- Custom shell prompt: zsh loads `~/.prompt`, bash builds the same prompt
  inline in `~/.bash_interactive`.
- TPM installation and automatic tmux plugin sync.
- `~/.local/bin` added to `PATH` by the bash and zsh settings.

### Changed

- `~/.dotfiles` is treated as a real checkout and fast-forwarded in place,
  never replaced by a symlink.
- The tmux-yank clipboard helper is only reported when missing; the installer
  never touches the system package manager.

[0.3.0]: https://github.com/saravenpi/dotfiles/releases/tag/v0.3.0
[0.2.0]: https://github.com/saravenpi/dotfiles/releases/tag/v0.2.0
[0.1.0]: https://github.com/saravenpi/dotfiles/releases/tag/v0.1.0
