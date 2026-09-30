# dotfiles

Personal dotfiles, linked into `$HOME` with [`tido`](./scripts/scripts/tido) — a
small dependency-free replacement for GNU Stow that ships with the dotfiles
themselves.

## Requirements

- `git`
- `curl` (only for the one-line install)

No `stow` package needed.

`tmux-yank` needs a clipboard helper (`wl-clipboard` on Wayland, `xclip`/`xsel`
on X11), which most distributions ship by default. If none is found the
installer warns about the requirement; it never modifies system packages itself.

The installer also sets up [mise](https://mise.jdx.dev): it installs the mise
binary into `~/.local/bin`, then runs `mise install` to fetch every tool declared
in `~/.config/mise/config.toml` — the language runtimes and CLIs. When mise
cannot be set up, the installer simply warns and moves on. The mise install
needs no elevated privileges: the shell settings add `~/.local/bin` to `PATH`.

The prompt is a small custom script: zsh loads `~/.prompt` and bash builds the
same prompt inline in `~/.bash_interactive`.

Tool installation is the slowest part of the install and needs network access.
Re-run `mise install` later to pick up any tools that failed or were added to the
config since.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/saravenpi/dotfiles/main/install.sh | bash
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
5. Installs [TPM](https://github.com/tmux-plugins/tpm) and syncs tmux plugins
6. Installs [mise](https://mise.jdx.dev) into `~/.local/bin` when missing
7. Installs every tool declared in `~/.config/mise/config.toml` (node, bun,
   go, ruby, python, ...) with `mise install`. This is the slow
   step: mise downloads runtimes and CLIs, so a partial failure only warns
8. Warns if the `tmux-yank` clipboard helper is missing (it is not installed
   for you)

## Packages

| Package   | Installs                                      |
| --------- | --------------------------------------------- |
| `bash`    | `~/.bashrc`, `~/.bash_profile`, `~/.bash_*`   |
| `zsh`     | `~/.zshrc`, `~/.zprofile`, `~/.zsh_*`, `~/.prompt` |
| `shell`   | `~/.aliases`, `~/.functions`, `~/.variables`  |
| `kitty`   | `~/.config/kitty`                             |
| `nvim`    | `~/.config/nvim`                              |
| `vim`     | `~/.vim`                                      |
| `mise`    | `~/.config/mise`                              |
| `tmux`    | `~/.tmux.conf`                                |
| `fonts`   | `~/.fonts`                                    |
| `scripts` | `~/scripts` (includes `tido`, added to `PATH`)|

`~/scripts` is added to `PATH` by the shell settings, so once the dotfiles are
linked `tido` runs from anywhere.

## Managing The Symlinks

```sh
tido                       # link every package into $HOME
tido kitty nvim            # link only these packages
tido list                  # dry run: show what would change
tido unlink nvim           # remove the links created for a package
tido --target DIR          # link into DIR instead of $HOME
tido -b DIR                # keep conflicting files here
```

Before `~/scripts` is on `PATH`, run it in place:
`./scripts/scripts/tido ...`.

`tido` folds a package directory into a single symlink when the target path does
not exist yet, descends into directories that already exist, and moves any real
file in the way into a backup instead of overwriting it. A directory that
several packages contribute to (such as `~/.config`, shared by `kitty`, `nvim`
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
right.
