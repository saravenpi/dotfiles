# dotfiles

Personal dotfiles, linked into `$HOME` with [`stow.sh`](./stow.sh) — a small
dependency-free replacement for GNU Stow.

## Requirements

- `git`
- `curl` (only for the one-line install)

No `stow` package needed.

`tmux-yank` needs a clipboard helper (`wl-clipboard` on Wayland, `xclip`/`xsel`
on X11), which most distributions ship by default. If none is found the
installer warns and prints the install command; it never modifies system
packages itself.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/saravenpi/dotfiles/main/install.sh | bash
```

Running the installer from a local checkout uses that checkout directly and
never re-clones over it.

### Manual install

```sh
git clone https://github.com/saravenpi/dotfiles ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
./stow.sh
```

## What The Installer Does

1. Picks a source checkout: a local clone if you are in one, otherwise `~/.dotfiles`
2. Initializes git submodules (the zsh-autosuggestions plugin lives in one)
3. Backs up conflicting files to `~/.config/config.old.<timestamp>/`
4. Links every package into `$HOME` with `./stow.sh` (conflicts are moved
   aside, never deleted)
5. Installs [TPM](https://github.com/tmux-plugins/tpm) and syncs tmux plugins
6. Warns if the `tmux-yank` clipboard helper is missing (it is not installed
   for you)

## Packages

| Package   | Installs                                     |
| --------- | -------------------------------------------- |
| `bash`    | `~/.bashrc`, `~/.bash_profile`, `~/.bash_*`  |
| `zsh`     | `~/.zshrc`, `~/.zprofile`, `~/.zsh_*`        |
| `shell`   | `~/.aliases`, `~/.functions`, `~/.variables` |
| `kitty`   | `~/.config/kitty`                            |
| `nvim`    | `~/.config/nvim`                             |
| `vim`     | `~/.vim`                                     |
| `mise`    | `~/.config/mise`                             |
| `tmux`    | `~/.tmux.conf`                               |
| `fonts`   | `~/.fonts`                                   |
| `scripts` | `~/scripts`                                  |

## Managing The Symlinks

```sh
./stow.sh                  # link every package into $HOME
./stow.sh kitty nvim       # link only these packages
./stow.sh list             # dry run: show what would change
./stow.sh unlink nvim      # remove the links created for a package
./stow.sh --target DIR     # link into DIR instead of $HOME
./stow.sh -b DIR           # keep conflicting files here
```

`stow.sh` folds a package directory into a single symlink when the target path
does not exist yet, descends into directories that already exist, and moves any
real file in the way into a backup instead of overwriting it. A directory that
several packages contribute to (such as `~/.config`, shared by `kitty`, `nvim`
and `mise`) is always kept as a real directory, with one symlink per package
inside it. It is safe to run repeatedly.

## Submodules

`zsh/.zsh/zsh-autosuggestions` is a git submodule pinned to a specific commit.
The installer initializes it; after a manual clone run
`git submodule update --init --recursive` before `./stow.sh`.

## Backups And Recovery

Nothing is ever deleted while installing:

- The installer copies existing config to `~/.config/config.old.<timestamp>/`.
- `stow.sh` moves conflicting files to `--backup DIR`
  (default `<target>/.stow-backups/<timestamp>/`), preserving their paths.

To recover an item, move it back from the backup directory to `$HOME` and
re-run `./stow.sh`. Backup directories are safe to delete once the install
looks right.

The installer points `~/.dotfiles` at the checkout that is actually linked into
`$HOME`, giving a stable path to the repository even when it lives somewhere
else, for example `~/Code/dotfiles`. `stow.sh` writes absolute symlinks, so the
links into `$HOME` point straight at the checkout.
