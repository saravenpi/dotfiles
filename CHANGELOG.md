# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `fonts`: ship `UndefinedNerdFont-Medium.otf`, the `undefined` monospace face
  patched with the Nerd Fonts v3.5.1 glyph set and named `Undefined Nerd Font`,
  plus the single-width `UndefinedNerdFontMono-Medium.otf` sibling named
  `Undefined Nerd Font Mono`.
- macOS support: the installer links the fonts into `~/Library/Fonts` (macOS
  does not scan `~/.local/share/fonts`), and the shell profiles only run the
  Linux-only Sway/XDG/wlroots setup on Linux.
- `install.sh`, `tido`, `palette-vis`: use `$DOTFILES` (exported by tiroir)
  when it points at a checkout, falling back to `~/.dotfiles`.
- `tido`: skip the Linux-only desktop packages (`foot`, `hypr`, `mako`,
  `niri`, `sway`, `waybar`, `widgets`) when linking every package on macOS.
- CI: a macOS job runs `tido` under the stock bash 3.2 with both the native
  and the no-`-f` `readlink`, then runs `install.sh` in a scratch `HOME`.

### Changed

- `foot`, `kitty`: use `Undefined Nerd Font Mono` as the terminal font.
- `sway`: title font reads `Undefined Nerd Font`.
- `shell`: `EDITOR` defaults to `vis` in bash and zsh, and `j` opens journal
  entries with it. A pre-set `EDITOR` or `MYBINS` (for example from tiroir) is
  now respected instead of overwritten, and zsh adds `MYBINS` to `PATH` like
  bash does. The README documents every environment variable the aliases use.

### Removed

- `tido update`: the linker only creates and removes links; updating the
  checkout is left to the installer and to git.

### Fixed

- `tido`: run on macOS again. The system `/bin/sh` is bash 3.2, whose
  command-substitution parser rejected the `case` that collects shared
  directories, and BSD `readlink` has no `-f`; the linker now uses a portable
  path resolver.
- `install.sh`: resolve a symlinked `~/.dotfiles` without `readlink -f`.
- `shell`: stop prepending the Linux-only `/home/sara/.local/bin` to `PATH`.
- `scripts`: `local-ip` skips loopback so it prints the same address on macOS
  and Linux.

## [0.13.1] - 2026-10-16

### Fixed

- `widgets`: dimmed exit dialog backdrop (`window.exit-overlay`) with 65% alpha.
- `widgets`: statusbar bottom margin set to 0 to eliminate double gap beneath the
  exclusive zone, preserving an exact 10 px gap below the bar.

## [0.13.0] - 2026-10-16

### Added

- `sway`: `$mod+Shift+e` triggers the new desktop `exit` widget (`~/.local/bin/exit`)
  replacing `swaynag` with a hard-edged, palette-themed modal dialog.
- `widgets`: `exit.css` added to the versioned stylesheets package at
  `~/.config/widgets/exit.css` with zero border radius and palette styling.

### Changed

- `sway`: outer gaps set to 0 (`gaps outer 0`). Because Sway adds outer gaps to
  inner gaps (`gaps_outer + gaps_inner`), setting outer gaps to 0 ensures window
  margins to screen edges and the statusbar exclusive zone are exactly 10 px,
  matching the desktop widgets' 10 px margins.
- `widgets`: all stylesheets (`statusbar.css`, `sidebar.css`, `launcher.css`)
  enforce `border-radius: 0`. The launcher query input has a 6 px bottom margin
  and zero chrome outline.

## [0.12.0] - 2026-10-15

### Added

- `fonts`: a `Helvetica` family (Regular, Bold, Italic, Bold Italic) in the
  dotfiles-backed `~/.local/share/fonts`. The four faces are TeX Gyre Heros
  v2.004 from CTAN with only their internal name table rewritten to read
  `Helvetica`, so Typst documents written with `#text(font: "Helvetica")`
  compile with real Helvetica metrics without a single line changed.
  `fonts/LICENSE-TeXGyreHeros.txt` carries the GUST Font License next to the
  derived files and the README records the provenance.
- `widgets`: `statusbar.css` styles the pill controls (volume, brightness,
  logout) and their slider popup card in the same material as the stat chips.

### Changed

- `widgets`: the statusbar's margin and padding are now 10 px, matching the
  gaps; the empty `.workspaces` and `.stats` rules are gone.
- `shell`: the `nvim` alias calls `nvim` directly instead of `bob run latest`.
- README: the packages section documents what the `fonts` package ships.

## [0.11.0] - 2026-10-14

### Added

- `widgets` package: the user-editable stylesheets for the statusbar, sidebar
  and launcher are now versioned in the dotfiles at `~/.config/widgets/*.css`.
  Each widget watches `~/.config/widgets/<name>.css` and restyles itself in
  place when it changes, the same way it already watched `palette.css`. Copy any
  widget's `style.css` there, edit it, and the widget picks it up without a
  restart.

### Changed

- `sway`: inner and outer gaps are now 10 px everywhere, matching the widgets'
  `theme::GAP` (the bar, sidebar and launcher all inset by the same measure the
  window rectangles use on every exposed screen edge).
- README: the widgets section now documents the per-widget stylesheet hot-reload.

## [0.10.0] - 2026-10-13

### Added

- `hypr`: a Hyprland config package at `~/.config/hypr`, the twin of the sway
  config. `hyprland.conf` starts the same widgets, sets the same keybinds and
  input options, disables animations, and draws borderless windows with a 12px
  corner radius and the widgets' 6px outer gap. `palette.conf` carries the
  colors from `palette sync` (Hyprland's `rgb(RRGGBB)` spelling plus
  `$active_border`, `$inactive_border` and `$urgent_border`), and
  `wallpaper.conf` is written by `setwallpaper`.
- `setwallpaper` records the image for Hyprland in
  `~/.config/hypr/wallpaper.conf` (`exec-once = swaybg …`, included by the
  Hyprland config), the same persistence sway gets from its snippet.

### Changed

- The session default is now **Hyprland**: `~/.profile`, `~/.zprofile` and
  `~/.bash_profile` start it on tty1 instead of sway. The sway config stays
  complete, so switching back is a one-line change.
- `sway`: the config is tidied into labelled sections and the commented-out dead
  binds are gone; behaviour is unchanged.
- `install.sh`: `~/.config/hypr` is included in the backup list.

## [0.9.0] - 2026-10-13

### Added

- `mako`: a notification-daemon config package at `~/.config/mako`. `config`
  sets the size, spacing and behaviour (the `undefined` font, top-right anchored
  popups, an 8s default timeout, grouping by app), and `palette.conf` carries
  the palette colors, generated by `palette sync` and pulled in with
  `include=`. The README explains that mako and the sidebar both serve
  `org.freedesktop.Notifications`, so only one runs at a time.

### Changed

- `sway`: windows are borderless — `default_border none` and
  `default_floating_border none`. Rounded corners are not supported by stock
  sway and would need the `swayfx` fork.
- `sway`: starts `~/.local/bin/sidebar` at login so the session's notification
  daemon is running before the first notification arrives, rather than only
  once `mod+n` is first pressed.
- Every synced palette snippet (kitty, foot, tmux, nvim, vim, sway, waybar) was
  refreshed to the current `palette/config.yml`, and the recorded wallpaper was
  updated with it.
- `nvim`: the completion and core plugin specs were trimmed.

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
