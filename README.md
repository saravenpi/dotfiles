# dotfiles

Personal dotfiles, linked into `$HOME` with [`tido`](./scripts/scripts/tido), a dependency-free symlink manager included in this repository.

## Requirements

Core dependencies:

- `git`
- `curl` (for the one-line install)

### macOS

The installer needs only `git` and `curl`; run `xcode-select --install` first if
`git` is missing. Homebrew is picked up automatically from `/opt/homebrew` or
`/usr/local` when it is installed.

The Linux desktop packages (`sway`, `hypr`, `foot`, `mako`, `niri`, `waybar`,
`widgets`) have no macOS equivalent and are left unused; `kitty` is the terminal.
Fonts are linked into `~/Library/Fonts` because macOS does not read
`~/.local/share/fonts`, and `setwallpaper` uses `osascript` instead of the
Wayland/X11 tools. The Linux-only session setup in the shell profiles (Sway on
tty1, XDG runtime directories, wlroots variables) is skipped automatically.

### Environment and edge cases

- Seat management: start Sway directly with `exec sway` from your login shell on tty1 (the shell profiles do this for you). Do not wrap it in `seatd-launch` or `dbus-run-session`; wrapping drops terminal session leadership and breaks DRM master acquisition in `libseat`. To use Hyprland instead, change the `exec` line in `~/.profile`, `~/.zprofile` and `~/.bash_profile` to `exec Hyprland`.
- Virtual machines: virtual DRM drivers (such as UTM or QEMU using `virtio-gpu`, VirtualBox, or VMware) lack hardware cursor planes and often fail to provide 3D hardware contexts. Shell profiles auto-detect virtual GPU devices and set `WLR_RENDERER=pixman` (switching the compositor to fast 2D CPU rendering to eliminate lag and buffer flickers), `WLR_NO_HARDWARE_CURSORS=1`, `WLR_SCENE_DISABLE_DIRECT_SCANOUT=1`, and `WLR_DRM_NO_MODIFIERS=1`. The sway output settings disable adaptive sync and set `max_render_time off`.
- Runtime directory: on distributions without systemd (Alpine with OpenRC, Void with runit), shell profiles fall back to creating `/tmp/user-$(id -u)` with mode `0700` if `XDG_RUNTIME_DIR` is not set.
- Clipboard: `tmux-yank` needs a clipboard helper — `wl-clipboard` on Wayland, or `xclip`/`xsel` on X11. `pbcopy` is used on macOS.

The installer also sets up [mise](https://mise.jdx.dev): it installs the mise
binary into `~/.local/bin`, then runs `mise install` to fetch every tool declared
in `~/.config/mise/config.toml` (the language runtimes and CLIs). When mise
cannot be set up, the installer simply warns and moves on. The mise install
needs no elevated privileges: the shell settings add `~/.local/bin` to `PATH`.

The prompt is a small custom script shared by both shells: `shell/.prompt` is
linked to `~/.prompt` and sourced by `~/.zshrc` and `~/.bashrc` alike, so bash
and zsh show the same prompt.

Tool installation is the slowest part of the install and needs network access.
Re-run `mise install` later to pick up any tools that failed or were added to the
config since.

## Environment Variables

The aliases, functions and a few scripts are driven by environment variables.
The recommended place to set them is the tiroir store: `~/.variables` runs
`tiroir export`, so every interactive shell gets them without putting machine
paths in the repository. Set only the ones your workflow uses; an alias built
from an unset variable degrades to `cd` with no argument.

The installer seeds the missing keys through `tiroir` with the defaults this
configuration expects: `DOTFILES` (the checkout it links), `WORKSPACE=~/Code`,
`WORKSPACE_PRO=~/Code/Facile`, `BRAIN=~/Documents/NuagePersonal/Wiki`,
`NUAGE=~/Documents/NuagePersonal`, `PORTALS=~/Portals`, `HARNESS=bulle`,
`EDITOR=vis`, `MYBINS=~/mybins` and `XDG_CONFIG_HOME=~/.config`. Existing
values are never overwritten. `SCHOOL` and `NTFY_SH` have no default because
only you can choose a school directory or an ntfy topic.

| Variable        | Used by | Purpose |
| --------------- | ------- | ------- |
| `DOTFILES`      | `install.sh`, `tido`, `palette-vis`, `god` | Path to this checkout. Tiroir exports it; the installer and `tido` fall back to `~/.dotfiles`. |
| `WORKSPACE`     | `goc` | Main workspace directory. |
| `WORKSPACE_PRO` | `gow` | Work/professional workspace directory. |
| `SCHOOL`        | `gos` | School directory. |
| `BRAIN`         | `gob`, `brain`, `b`, `bnn`, `j` | Notes vault. `j` writes to `$BRAIN/Journal` and reads `$BRAIN/Templates/daily_template.md`. |
| `NUAGE`         | `gon` | Local Nuage files directory. |
| `PORTALS`       | `cportal` | Directory holding portal YAML files. |
| `HARNESS`       | `a` (when `bulle` is installed) | Command the `a` alias runs. |
| `NTFY_SH`       | `tellme` | ntfy.sh topic URL used for notifications. |
| `EDITOR`        | `e` and the `c*`/`brain` aliases, `j` | Editor command. Defaults to `vis`; override it in tiroir or the environment. |
| `MYBINS`        | `~/.bash_settings`, `~/.zsh_settings` | Local binary directory added to `PATH`; defaults to `~/mybins`. |
| `XDG_CONFIG_HOME` | `setwallpaper` | Config root; defaults to `~/.config`. |
| `WLR_RENDERER`  | sway on Linux | Optional renderer override (`pixman` on VMs); detected automatically when a virtual GPU is present. |

`ANDROID_HOME` is discovered from the usual SDK locations. `DISPLAY`,
`WAYLAND_DISPLAY`, `SWAYSOCK`, `NIRI_SOCKET`, `HYPRLAND_INSTANCE_SIGNATURE`,
`XDG_CURRENT_DESKTOP`, `TMUX` and `TMUX_PANE` come from the running session:
`setwallpaper` and the shell helpers use them to pick a backend, and none of
them need to be set by hand. `XDG_RUNTIME_DIR` is created on Linux when missing.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/saravenpi/dotfiles/main/install.sh | sh
```

Run from a checkout (`./install.sh`) and that checkout is used as-is; the
installer never clones over a local checkout.

The checkout is taken from `$DOTFILES` when that variable is set (tiroir exports
it), otherwise from `~/.dotfiles`. The repository lives there as a **real
clone**: it is cloned when missing and fast-forwarded with `git pull` when
present. It is never replaced by a symlink.

### Manual install

```sh
git clone https://github.com/saravenpi/dotfiles ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
./scripts/scripts/tido
```

## What The Installer Does

1. Picks a source: `$DOTFILES` when it is set, then a real clone at
   `~/.dotfiles`, then the checkout it was run from
2. Initializes git submodules (the zsh-autosuggestions plugin lives in one)
3. Backs up conflicting files to `~/.config/config.old.<timestamp>/`
4. Links every package into `$HOME` with `tido` (conflicts are moved aside,
   never deleted)
5. On macOS, links the fonts into `~/Library/Fonts`
6. Installs [mise](https://mise.jdx.dev) into `~/.local/bin` when missing
7. Installs every tool declared in `~/.config/mise/config.toml` (bun,
   go, python, ...) with `mise install`. This is the slow
   step: mise downloads runtimes and CLIs, so a partial failure only warns
8. Seeds the missing environment defaults in `tiroir` (see above), leaving
   every value already in the store untouched
9. Warns if the `tmux-yank` clipboard helper is missing (it is not installed
   for you)

## Packages

| Package   | Installs                                      |
| --------- | --------------------------------------------- |
| `bash`    | `~/.bashrc`, `~/.bash_profile`, `~/.bash_*`   |
| `shell`   | `~/.aliases`, `~/.functions`, `~/.variables`, `~/.prompt` |
| `nvim`    | `~/.config/nvim`                              |
| `vim`     | `~/.vim`                                      |
| `vis`     | `~/.config/vis` (default editor)              |
| `mise`    | `~/.config/mise`                              |
| `tmux`    | `~/.config/tmux/tmux.conf`, `~/.config/tmux/plugins` |
| `fonts`   | `~/.local/share/fonts` (Helvetica, undefined Nerd Font), linked into `~/Library/Fonts` on macOS |
| `scripts` | `~/scripts` (includes `tido` and `setwallpaper`, added to `PATH`) |
| `facile`  | `~/.facile.yml`                               |
| `bulle`   | `~/.bulle.yml`, `~/.bulle/profiles`, `~/.bulle/jobs` |
| `sway`    | `~/.config/sway` (the alternative session)    |
| `hypr`    | `~/.config/hypr` (Hyprland, the default session) |
| `foot`    | `~/.config/foot`                              |
| `kitty`   | `~/.config/kitty` (kitty.conf + palette colors) |
| `mako`    | `~/.config/mako` (config + palette colors)    |
| `yazi`    | `~/.config/yazi` (palette-generated theme)    |

On macOS the Linux-only desktop packages (`foot`, `hypr`, `mako`, `niri`,
`sway`, `waybar`, `widgets`) are skipped when linking every package. Name one
explicitly (`tido link sway`) to link it anyway; `tido unlink` still visits
them so links left by an older install can be removed.

`palette sync` writes Yazi's theme to `~/.config/yazi/theme.toml`, which the
`yazi` package versions. Yazi merges it over its built-in dark/light preset,
so only the colors are managed here; layout, icons and keymaps stay in
`yazi.toml` and `keymap.toml`. Yazi reads the theme at startup, so restart it
after a palette change (requires `palette` 0.12.0 or newer).

The `fonts` package also ships a **Helvetica** family
(`texgyreheros-{regular,bold,italic,bolditalic}.otf`, next to
`fonts/LICENSE-TeXGyreHeros.txt`). Helvetica is a commercial Monotype typeface,
so those files are [TeX Gyre Heros](https://mirrors.ctan.org/fonts/tex-gyre.zip)
v2.004 from CTAN — a metrically identical revival — with only their internal
name table rewritten so the family reads `Helvetica`. A Typst document written
with `#text(font: "Helvetica")` therefore compiles with real Helvetica metrics
without a single line changed, and any other fontconfig program finds the same
family under the same name. The copyright strings inside the OTFs and the GUST
Font License are untouched.

The `fonts` package also ships `UndefinedNerdFont-Medium.otf`, the `undefined`
monospace face patched with the Nerd Fonts v3.5.1 glyph set and named
`Undefined Nerd Font`, plus the single-width `UndefinedNerdFontMono-Medium.otf`
sibling named `Undefined Nerd Font Mono`. `foot` and `kitty` use the Mono
variant as their terminal font, and the sway title font uses
`Undefined Nerd Font`.

Desktop widgets (statusbar, sidebar, launcher) live in the separate
[saravenpi/widgets](https://github.com/Saravenpi/widgets) Cargo workspace;
`make install` puts their binaries in `~/.local/bin`, which the Hyprland and
sway configs start. `palette sync` writes the shared colors to
`~/.config/widgets/palette.css`; the widgets watch that file and restyle
themselves the moment it changes, so no restart is needed. Each widget also
reads its own stylesheet from `~/.config/widgets/<name>.css` (for example
`~/.config/widgets/statusbar.css`) when that file exists, and watches it for
changes — copy any widget's `style.css` there, edit it, and the widget
restyles in place. When the file is absent the widget falls back to its
compiled-in default. Sway re-applies the palette on every reload
(`exec_always palette sync --no-reload`), so `mod+Shift+r` also refreshes
the widgets there; the Hyprland config runs `palette sync --no-reload` once
at login.

## Notifications

Two programs here can serve Wayland notifications, and only one can run at a
time: a session bus has exactly one owner of `org.freedesktop.Notifications`.

- The **sidebar** from [saravenpi/widgets](https://github.com/Saravenpi/widgets)
  is the default. It owns the bus name from login, keeps the last 50
  notifications in `$XDG_STATE_HOME/widgets/notifications.json`, shows them in
  the top-right as they arrive and lists the history under `mod+n`. Hyprland
  starts it from `~/.config/hypr/hyprland.conf` and sway from
  `~/.config/sway/config`; `mako` must not run alongside it.
- **mako** is the alternative. Its config is packaged here (`~/.config/mako`):
  `config` sets the size, spacing and behaviour, and `palette.conf` carries the
  colors, generated by `palette sync` and pulled in with `include=`. To use mako
  instead, start `mako` and drop the `sidebar` line from the Hyprland or sway
  config.

`palette sync` reloads a running mako with `makoctl reload`, so either choice
stays on the same colors as the rest of the desktop.

## Wallpaper

`setwallpaper <image>` records the image in `~/.config/wallpaper` and applies it
to the running session. On sway it also regenerates
`~/.config/sway/wallpaper.conf` (`output * bg <image> fill`, included by the
sway config); on Hyprland it writes `~/.config/hypr/wallpaper.conf`
(`exec-once = swaybg …`, included by the Hyprland config), so the same image
comes back after a reload or a restart; a niri config gets the equivalent
`~/.config/niri/wallpaper.kdl` once `include "wallpaper.kdl"` is added to it by
hand. Other Wayland compositors use
a `swaybg` daemon, X11 uses the first of `feh`, `xwallpaper`, `nitrogen` and
`hsetroot` that is installed, GNOME/KDE/XFCE use their own tools, and macOS uses
`osascript` (`-a`/`--all-spaces` sets every Space).

Once the image is applied, `setwallpaper` runs `palette generate <image> -s`:
it regenerates `~/.config/palette/config.yml` from the new wallpaper and syncs
every target (Kitty, tmux, Neovim, sway, Hyprland, foot, waybar, widgets, mako,
Yazi and Vim). A missing or failing `palette` only prints a warning; the
wallpaper change itself still succeeds.

`~/scripts` is added to `PATH` by the shell settings, so once the dotfiles are
linked `tido` runs from anywhere.

## Managing The Symlinks

```sh
tido                       # show usage help
tido link                  # link every package into $HOME
tido link nvim tmux        # link only these packages
tido list                  # dry run: show what would change
tido clean                 # remove backup directories
tido unlink nvim           # remove the links created for a package
tido link --target DIR     # link into DIR instead of $HOME
tido link -b DIR           # keep conflicting files here
```

Before `~/scripts` is on `PATH`, run it in place:
`./scripts/scripts/tido ...`.

`tido` reads `$DOTFILES` when it is set and otherwise finds the checkout from
its own resolved path. It does not depend on GNU `readlink -f`: it follows the
link chain one hop at a time and resolves the parent with `pwd -P`, which works
on older macOS and BusyBox too. It folds a package directory into a single
symlink when the target path does not exist yet, descends into directories that
already exist, and moves any real file in the way into a backup instead of
overwriting it. A directory that several packages contribute to (such as
`~/.config`, shared by `nvim` and `mise`) is always kept as a real directory,
with one symlink per package inside it. Links are always written as absolute
paths, and a relative link left behind by GNU stow is rewritten the next time
`tido` runs. It is safe to run repeatedly.

## Submodules

`zsh/.zsh/zsh-autosuggestions` is a git submodule pinned to a specific commit.
The installer initializes it; after a manual clone run
`git submodule update --init --recursive` before `tido`.

## Continuous Integration

The macOS job (`.github/workflows/macos.yml`) runs `tido` under the system
bash 3.2, the oldest shell it has to support. `readlink -f` only exists on
macOS 12.3 and newer, so the job installs a `readlink` shim that rejects `-f`:
`tido` must keep working through its portable fallback. A second run without
the shim covers the native resolver on current macOS. The same job then runs
`install.sh` in a scratch `HOME` and asserts the backup, the links and the
fonts in `~/Library/Fonts`.

The Linux job (`.github/workflows/linux.yml`) runs `install.sh` in a scratch
`HOME` under the runner's `/bin/sh` (dash), with mise and facile stubbed out,
and asserts the backup and the desktop-package links. Both jobs stub the
network installers, so they exercise the scripts instead of downloading
toolchains.

## Backups And Recovery

Nothing is ever deleted while installing:

- The installer copies existing config to `~/.config/config.old.<timestamp>/`.
- `tido` moves conflicting files to `--backup DIR`
  (default `<target>/.tido-backups/<timestamp>/`), preserving their paths.

To recover an item, move it back from the backup directory to `$HOME` and
re-run `tido`. Backup directories are safe to delete once the install looks
right; run `tido clean` to remove all backup directories.
