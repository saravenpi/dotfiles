# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[0.2.0]: https://github.com/saravenpi/dotfiles/releases/tag/v0.2.0
[0.1.0]: https://github.com/saravenpi/dotfiles/releases/tag/v0.1.0
