# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.0] - 2026-10-12

### Added

- `waybar`: `style.css` imports `palette.css` and uses `@palette_bg`,
  `@palette_fg`, `@palette_cursor` and `@palette_color0`..`@palette_color15`
  instead of hard-coded hexes, so the bar follows the generated theme.
  Requires `palette` 0.7.0 or newer.

### Changed

- `install.sh`: `tiroir` and `palette` are installed only when missing, the
  palette sync also looks at `~/.config/palette/config.yml`, and the dotfiles
  are re-linked with tido after the tool installs.
- `tido update`: re-links the dotfiles itself after running install.sh, even
  when the installer exits early.

## [0.5.2] - 2026-10-11

### Changed

- `tmux`: `status.conf` sources `palette.conf` first and takes its muted grey
  from `#{@palette_color8}` instead of the hard-coded `colour242`, so `palette`
  no longer overrides the status style. Requires `palette` v0.6.0.

### Fixed

- `foot`: `palette.ini` uses the `[colors-dark]` section with `cursor=` inside
  it. foot removed `[colors]` in 1.28.0 and `[cursor] color=` in 1.26.0 and
  rejected the previous output.

## [0.5.1] - 2026-10-11

### Added

- `palette` package: canonical color scheme stored in `~/.config/palette/config.yml` generated from the modernist wallpaper.
- `foot` integration: includes `~/.config/foot/palette.ini` with dynamic ANSI colors, cursor, and selection styles.
- `sway` bar wrapper: added `~/.config/sway/bar.sh` detecting `waybar` dynamically and falling back to `swaybar`.
- `install.sh`: added `palette` to default backup list.

## [0.5.0] - 2026-10-11

### Added

- Sway stack: natural scrolling for pointer and touchpad, dynamic palette integration via `include ~/.config/sway/palette.conf`, and Waybar integration with fallback to swaybar.
- Waybar: `bar-0` identifier, `sway/workspaces` module integration, and styled workspace buttons matching the palette.
- Installer: automated setup for `facile`, `tiroir`, and `palette` CLIs by default, with automatic initial palette synchronization.
- `tido`: rewritten in pure POSIX `/bin/sh` without bashisms, process substitutions, or here-strings; added `clean-backups` command and automatic git pull in `tido update`; runs portably on BusyBox ash, dash, and sh.
- `tido` performance: parameter expansion directory parsing and cached symlink resolution eliminating subshell fork bottlenecks.
- Environment: exported `NO_AT_BRIDGE=1` and `GTK_USE_PORTAL=0` preventing GTK3 accessibility bridge and portal freezes on Alpine and VMs.
- The installer now warns at the end of a run when zsh is not the login shell, printing the exact `chsh -s` command to run. It never runs `chsh` itself: PAM needs a password and BusyBox ships no `chsh`.
- `install.sh`: removed bash dependency; executes tido via POSIX `sh`.
- `shell` package: converted `.prompt` and `.variables` to pure POSIX compliance with default sh prompt fallback.
- `sway` package: zero-dependency status command, inner/outer gaps, disabled adaptive sync, window borders, theme palette, and wallpaper configuration via `swaybg`.
- `foot` package: modern Wayland terminal emulator configured with zsh shell, GohuFont, modern `[colors-dark]` section, and matching color palette.
- `wmenu`: integrated launcher styled with the dotfiles palette.
- `fonts` package: migrated from deprecated `~/.fonts` to XDG standard `~/.local/share/fonts`.
- Shell profiles (`.zprofile`, `.bash_profile`, `.profile`, `.variables`): universal top-level `XDG_RUNTIME_DIR` initialization, anti-flicker Wayland environment flags (`WLR_NO_HARDWARE_CURSORS`, `WLR_SCENE_DISABLE_DIRECT_SCANOUT`, `WLR_DRM_NO_MODIFIERS`), automatic `WLR_RENDERER=pixman` detection in virtual machines, and auto-launch Sway on TTY1.
- `README.md`: added multi-distribution fresh install requirements (Alpine, Void, Arch, Debian) and Wayland edge cases.
- `niri` package: full standard layout, column manipulation, screenshot, and hardware keybindings.
- `rofi` package: custom dark theme matching the modernist color scheme.
- `waybar` package: custom status bar with native workspaces and window integration.
- `install.sh`: package and backup sway, foot, niri, rofi, and waybar configurations.

## [0.4.1] - 2026-10-11

### Fixed

- Restored the vendored `tmux-yank` plugin: v0.4.0's plugin trimming deleted `yank.tmux` and `scripts/` along with the upstream docs, and the follow-up commit dropped its `run-shell` line from `plugins.conf`.

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
