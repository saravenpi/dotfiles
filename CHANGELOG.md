# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.8.0] - 2026-10-13

### Added

- `setwallpaper`, a script in the `scripts` package, replaces the `setwallpaper`
  shell function. It sets the wallpaper on Wayland (sway natively, niri,
  Hyprland and any other wlr-layer-shell compositor through `swaybg`), X11
  (`feh`, `xwallpaper`, `nitrogen`, `hsetroot`), GNOME, KDE, XFCE, and macOS,
  and records the chosen image in `~/.config/wallpaper` so the choice survives a
  reload or a re-login. No shell startup is needed to change a wallpaper.
- The sway config includes `~/.config/sway/wallpaper.conf`, generated from
  `~/.config/wallpaper` by `setwallpaper`, so the wallpaper survives
  `swaymsg reload` and a restart without editing the config by hand.

### Changed

- `sway` re-applies the palette on every reload with `exec_always palette sync
  --no-reload`. Combined with the widgets' new palette hot-reload, pressing
  `mod+Shift+r` restyles the bar, sidebar and launcher in place.

## [0.7.1] - 2026-10-13

### Fixed

- `tido update` links the dotfiles exactly once. It stops after `install.sh`
  has linked and only runs its own link pass when the installer fails, instead
  of linking a second time on top of a successful install.
- `install.sh` links every package: `tido link` runs without a hardcoded list,
  so `bulle`, `palette` and `wallpapers` are linked by the installer itself
  rather than being left to `tido`'s second pass.
- `install.sh` no longer sources `~/.functions` in the final summary. That file
  is bash, and sourcing it under `sh` with `set -eu` aborted the installer with
  exit status 2, which made `tido update` treat a successful install as a
  failure and re-link.

## [0.7.0] - 2026-10-13

### Added

- `kitty`: restored `kitty.conf` with the `undefined` font, translucent window,
  remote control socket, and colors from `palette.conf`; paste confirmations
  disabled via `paste_actions`.
- Desktop widgets (statusbar, sidebar, launcher) moved to the separate
  [saravenpi/widgets](https://github.com/Saravenpi/widgets) Cargo workspace;
  the sway config starts `~/.local/bin/statusbar`, `mod+n` toggles the sidebar
  and `mod+space` opens the launcher. The facile catalog entry `widgets:`
  points at that repo.

### Changed

- Default font switched from GohuFont to `undefined` (https://undefined-medium.com)
  across sway and foot; the GohuFont file was dropped from `fonts`.
- `vim`: `.vimrc` loads the `palette` colorscheme instead of `dracula`, so the
  editor takes the same colors as the rest of the desktop.

### Removed

- `waybar`, `niri` and `rofi` packages. The sway `bar {}` block and wmenu are
  gone; widgets replaced them.

### Fixed

- `install.sh`: runs the tido link pass once per install again. The duplicate
  final re-link shipped in 0.6.0 made `tido update` link twice in a row.
- `tido update`: re-links only when the installer exited non-zero, since a
  successful installer already linked after pulling.

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
