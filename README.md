# dotfiles

Personal dotfiles, linked into `$HOME` with [`tido`](./scripts/scripts/tido), a dependency-free symlink manager included in this repository.

## Requirements

Core dependencies:

- `git`
- `curl` (for the one-line install)

### Fresh install by distribution

The installer sets up user configuration and tools. Run the command for your distribution to install build essentials (required by mise for compiling Python, Node, and C/Rust tools) and the Sway Wayland desktop stack. The **Hyprland** package is also included as a fully configured alternative session.

#### Alpine Linux

Install build dependencies and desktop packages:

```sh
apk add build-base linux-headers libffi-dev openssl-dev bzip2-dev zlib-dev readline-dev sqlite-dev
apk add sway swaybg foot wmenu seatd udev mesa-dri-gallium font-dejavu wl-clipboard zsh
```

Enable hardware seat management and add your user to device groups:

```sh
setup-devd udev
rc-update add seatd
rc-service seatd start
adduser "$USER" seat
adduser "$USER" video
adduser "$USER" input
```

#### Void Linux

Install build dependencies and desktop packages:

```sh
xbps-install -S base-devel linux-headers libffi-devel openssl-devel bzip2-devel zlib-devel readline-devel sqlite-devel
xbps-install -S sway swaybg foot wmenu seatd mesa-dri font-dejavu wl-clipboard zsh
```

Enable the seat daemon and add your user to groups:

```sh
ln -s /etc/sv/seatd /var/service/
usermod -aG _seatd,video,input "$USER"
```

#### Arch Linux

Install build dependencies and desktop packages:

```sh
pacman -S base-devel linux-headers
pacman -S sway swaybg foot wmenu wl-clipboard ttf-dejavu zsh
```

Seat management is handled automatically by `systemd-logind`.

#### Debian and Ubuntu

Install build dependencies and desktop packages:

```sh
apt update
apt install build-essential linux-headers-generic libssl-dev libffi-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
apt install sway swaybg foot wmenu wl-clipboard fonts-dejavu zsh
```

Seat management is handled automatically by `systemd-logind`.

The commands above install the sway stack (and the Hyprland alternative). The session starts Sway by default; if you would rather use Hyprland, both configs are complete — change the `exec` line in `~/.profile`, `~/.zprofile` and `~/.bash_profile` to `exec Hyprland`.

### Environment and edge cases

- Seat management: start Sway directly with `exec sway` from your login shell on tty1 (the shell profiles do this for you). Do not wrap it in `seatd-launch` or `dbus-run-session`; wrapping drops terminal session leadership and breaks DRM master acquisition in `libseat`.
- Virtual machines: virtual DRM drivers (such as UTM or QEMU using `virtio-gpu`, VirtualBox, or VMware) lack hardware cursor planes and often fail to provide 3D hardware contexts. Shell profiles auto-detect virtual GPU devices and set `WLR_RENDERER=pixman` (switching the compositor to fast 2D CPU rendering to eliminate lag and buffer flickers), `WLR_NO_HARDWARE_CURSORS=1`, `WLR_SCENE_DISABLE_DIRECT_SCANOUT=1`, and `WLR_DRM_NO_MODIFIERS=1`. The sway output settings disable adaptive sync and set `max_render_time off`.
- Runtime directory: on distributions without systemd (Alpine with OpenRC, Void with runit), shell profiles fall back to creating `/tmp/user-$(id -u)` with mode `0700` if `XDG_RUNTIME_DIR` is not set.
- Clipboard: `tmux-yank` requires a Wayland clipboard helper (`wl-clipboard`), included in the desktop package lists above.

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

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/saravenpi/dotfiles/main/install.sh | sh
```

Run from a checkout (`./install.sh`) and that checkout is used as-is; the
installer never clones over a local checkout.

The repository lives at `~/.dotfiles` as a **real clone**. It is cloned when
missing and fast-forwarded with `git pull` when present. It is never replaced by
a symlink.

### Manual install

```sh
git clone https://github.com/saravenpi/dotfiles ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
./scripts/scripts/tido
```

## What The Installer Does

1. Picks a source: a real clone at `~/.dotfiles` if there is one, otherwise the
   checkout it was run from
2. Initializes git submodules (the zsh-autosuggestions plugin lives in one)
3. Backs up conflicting files to `~/.config/config.old.<timestamp>/`
4. Links every package into `$HOME` with `tido` (conflicts are moved aside,
   never deleted)
5. Installs [mise](https://mise.jdx.dev) into `~/.local/bin` when missing
6. Installs every tool declared in `~/.config/mise/config.toml` (bun,
   go, python, ...) with `mise install`. This is the slow
   step: mise downloads runtimes and CLIs, so a partial failure only warns
7. Warns if the `tmux-yank` clipboard helper is missing (it is not installed
   for you)

## Packages

| Package   | Installs                                      |
| --------- | --------------------------------------------- |
| `bash`    | `~/.bashrc`, `~/.bash_profile`, `~/.bash_*`   |
| `shell`   | `~/.aliases`, `~/.functions`, `~/.variables`, `~/.prompt` |
| `nvim`    | `~/.config/nvim`                              |
| `vim`     | `~/.vim`                                      |
| `mise`    | `~/.config/mise`                              |
| `tmux`    | `~/.config/tmux/tmux.conf`, `~/.config/tmux/plugins` |
| `fonts`   | `~/.local/share/fonts`                        |
| `scripts` | `~/scripts` (includes `tido` and `setwallpaper`, added to `PATH`) |
| `facile`  | `~/.facile.yml`                               |
| `bulle`   | `~/.bulle.yml`, `~/.bulle/profiles`, `~/.bulle/jobs` |
| `sway`    | `~/.config/sway` (the alternative session)    |
| `hypr`    | `~/.config/hypr` (Hyprland, the default session) |
| `foot`    | `~/.config/foot`                              |
| `kitty`   | `~/.config/kitty` (kitty.conf + palette colors) |
| `mako`    | `~/.config/mako` (config + palette colors)    |

Desktop widgets (statusbar, sidebar, launcher) live in the separate
[saravenpi/widgets](https://github.com/Saravenpi/widgets) Cargo workspace;
`make install` puts their binaries in `~/.local/bin`, which the Hyprland and
sway configs start. `palette sync` writes the shared colors to
`~/.config/widgets/palette.css`; the widgets watch that file and restyle
themselves the moment it changes, so no restart is needed. Sway re-applies the
palette on every reload (`exec_always palette sync --no-reload`), so
`mod+Shift+r` also refreshes the widgets there; the Hyprland config runs
`palette sync --no-reload` once at login.

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

`~/scripts` is added to `PATH` by the shell settings, so once the dotfiles are
linked `tido` runs from anywhere.

## Managing The Symlinks

```sh
tido                       # show usage help
tido link                  # link every package into $HOME
tido link nvim tmux        # link only these packages
tido list                  # dry run: show what would change
tido clean-backups         # remove backup directories
tido update                # pull the repo and re-run install.sh (from anywhere)
tido unlink nvim           # remove the links created for a package
tido link --target DIR     # link into DIR instead of $HOME
tido link -b DIR           # keep conflicting files here
```

Before `~/scripts` is on `PATH`, run it in place:
`./scripts/scripts/tido ...`.

`tido` folds a package directory into a single symlink when the target path does
not exist yet, descends into directories that already exist, and moves any real
file in the way into a backup instead of overwriting it. A directory that
several packages contribute to (such as `~/.config`, shared by `nvim`
and `mise`) is always kept as a real directory, with one symlink per
package inside it. Links are always written as absolute paths, and a relative
link left behind by GNU stow is rewritten the next time `tido` runs. It is safe
to run repeatedly.

## Submodules

`zsh/.zsh/zsh-autosuggestions` is a git submodule pinned to a specific commit.
The installer initializes it; after a manual clone run
`git submodule update --init --recursive` before `tido`.

## Backups And Recovery

Nothing is ever deleted while installing:

- The installer copies existing config to `~/.config/config.old.<timestamp>/`.
- `tido` moves conflicting files to `--backup DIR`
  (default `<target>/.tido-backups/<timestamp>/`), preserving their paths.

To recover an item, move it back from the backup directory to `$HOME` and
re-run `tido`. Backup directories are safe to delete once the install looks
right; run `tido clean-backups` to remove all backup directories.
