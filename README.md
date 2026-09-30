# dotfiles

Personal dotfiles, linked into `$HOME` with [`stow.sh`](./stow.sh) — a small
dependency-free replacement for GNU Stow.

## Requirements

- `git`
- `curl` (only for the one-line install)

No `stow` package needed.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/saravenpi/dotfiles/main/install.sh | bash
```

Running the installer from a local checkout uses that checkout directly and
never re-clones over it.

## What The Installer Does

1. Picks a source checkout: a local clone if you are in one, otherwise `~/.dotfiles`
2. Backs up conflicting files to `~/.config/config.old.<timestamp>/`
3. Links every package into `$HOME` with `./stow.sh` (conflicts are moved
   aside, never deleted)
4. Installs [TPM](https://github.com/tmux-plugins/tpm) and syncs tmux plugins

## Packages

| Package   | Installs                                                    |
| --------- | ----------------------------------------------------------- |
| `bash`    | `~/.bashrc`, `~/.bash_profile`, `~/.bash_*`                 |
| `zsh`     | `~/.zshrc`, `~/.zprofile`, `~/.zsh_*`                       |
| `shell`   | `~/.aliases`, `~/.functions`, `~/.variables`                |
| `kitty`   | `~/.config/kitty`                                           |
| `nvim`    | `~/.config/nvim`                                            |
| `vim`     | `~/.vim`                                                    |
| `mise`    | `~/.config/mise`                                            |
| `tmux`    | `~/.tmux.conf`                                              |
| `fonts`   | `~/.fonts`                                                  |
| `scripts` | `~/scripts`                                                 |

## Managing The Symlinks

```sh
./stow.sh                  # link every package into $HOME
./stow.sh kitty nvim       # link only these packages
./stow.sh list             # dry run: show what would change
./stow.sh unlink nvim      # remove the links created for a package
./stow.sh --target DIR     # link into DIR instead of $HOME
./stow.sh -b DIR           # keep conflicting files here
```
