#!/bin/sh
#
# Dotfiles installer.
#
# Reuses (or clones) the dotfiles repository and symlinks every package into
# $HOME using ./scripts/scripts/tido (installed as `tido`), a dependency-free
# replacement for GNU Stow. Conflicting files are moved into a timestamped
# backup directory; nothing is deleted during the install.


set -eu
# shellcheck disable=SC3040
set -o pipefail 2>/dev/null || true

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

BACKUP_DIR="$HOME/.config/config.old.$(date +%Y%m%d_%H%M%S)"
DOTFILES_LINK="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/saravenpi/dotfiles"

SOURCE_DIR=""

info() {
    printf '%b::  %s%b\n' "${BLUE}" "$*" "${NC}"
}

success() {
    printf '%b  + %s%b\n' "${GREEN}" "$*" "${NC}"
}

warn() {
    printf '%b  ! %s%b\n' "${YELLOW}" "$*" "${NC}"
}

error() {
    printf '%b  x %s%b\n' "${RED}" "$*" "${NC}"
}

show_banner() {
    printf '%b' "${CYAN}"
    printf ' /\\_/\\\n'
    printf '( o.o )\n'
    printf ' > ^ <\n'
    printf '%b' "${NC}"
    printf '%b=======================================%b\n' "${WHITE}" "${NC}"
    printf '%b    Dotfiles Configuration Installer%b\n' "${WHITE}" "${NC}"
    printf '%b    by @saravenpi%b\n' "${WHITE}" "${NC}"
    printf '%b=======================================%b\n\n' "${WHITE}" "${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_dependencies() {
    info "Checking dependencies..."

    missing_deps=""

    command_exists git || missing_deps="$missing_deps git"
    if ! command_exists curl && ! command_exists wget; then
        missing_deps="$missing_deps curl-or-wget"
    fi

    if [ -n "$missing_deps" ]; then
        error "Missing required dependencies:${missing_deps}"
        printf '\n%bPlease install the missing dependencies first:%b\n' "${YELLOW}" "${NC}"
        printf '%bSee installation instructions at: https://github.com/saravenpi/dotfiles#requirements%b\n' "${WHITE}" "${NC}"
        exit 1
    fi

    success "All dependencies are installed"
}

# Work out where the dotfiles live.
#
# A real checkout at ~/.dotfiles is the source of truth: it is used and updated
# in place, and it is never replaced by a symlink. An earlier installer did
# exactly that, moving the user's clone aside and leaving ~/.dotfiles a link.
resolve_source() {
    script_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"

    # 1. A real checkout at ~/.dotfiles - the canonical location.
    if [ -d "$DOTFILES_LINK/.git" ] && [ ! -L "$DOTFILES_LINK" ]; then
        SOURCE_DIR="$DOTFILES_LINK"
        info "Using checkout: $SOURCE_DIR"
        update_repo
        return 0
    fi

    # 2. ~/.dotfiles is a symlink to a checkout (made by an older installer).
    #    Keep working from it, but never create one again.
    if [ -L "$DOTFILES_LINK" ]; then
        resolved="$(readlink -f -- "$DOTFILES_LINK" 2>/dev/null || true)"
        if [ -n "$resolved" ] && [ -d "$resolved" ]; then
            SOURCE_DIR="$resolved"
            warn "$DOTFILES_LINK is a symlink to $SOURCE_DIR; a real clone is preferred"
            return 0
        fi
        warn "Removing dangling symlink: $DOTFILES_LINK"
        rm -- "$DOTFILES_LINK"
    fi

    # 3. Running from a local checkout never clones over it.
    if [ -f "$script_dir/install.sh" ] && [ -d "$script_dir/scripts" ]; then
        SOURCE_DIR="$script_dir"
        info "Using local checkout: $SOURCE_DIR"
        return 0
    fi

    # 4. Something else lives at ~/.dotfiles - preserve it, then clone.
    if [ -e "$DOTFILES_LINK" ]; then
        mkdir -p -- "$BACKUP_DIR"
        mv -- "$DOTFILES_LINK" "$BACKUP_DIR/.dotfiles-pre-existing"
        warn "Existing $DOTFILES_LINK moved to $BACKUP_DIR/.dotfiles-pre-existing"
    fi

    info "Cloning dotfiles into $DOTFILES_LINK"
    if git clone --depth 1 "$DOTFILES_REPO" "$DOTFILES_LINK"; then
        SOURCE_DIR="$DOTFILES_LINK"
        success "Repository cloned"
    else
        error "Failed to clone dotfiles repository"
        exit 1
    fi
}

# Fast-forward an existing checkout. A failed update is not fatal: the local
# copy is still usable.
update_repo() {
    git -C "$SOURCE_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

    info "Updating repository..."
    if git -C "$SOURCE_DIR" pull --ff-only; then
        success "Repository updated"
    else
        warn "Could not update the repository, using the local copy as-is"
    fi
}

# Materialize git submodules. The zsh-autosuggestions plugin lives in one, so
# a fresh clone would otherwise be missing it.
init_submodules() {
    [ -f "$SOURCE_DIR/.gitmodules" ] || return 0

    if ! git -C "$SOURCE_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        return 0
    fi

    info "Initializing submodules..."
    if git -C "$SOURCE_DIR" submodule update --init --recursive; then
        success "Submodules ready"
    else
        warn "Could not initialize submodules"
    fi
}

# Copy one existing item into the backup directory. Symlinks are skipped: they
# are recreated by tido and the link itself carries no data.
backup_item() {
    src="$1"
    dest="$2"
    label="$3"

    [ -e "$src" ] || return 1
    [ -L "$src" ] && return 1

    mkdir -p -- "$(dirname -- "$dest")"

    if cp -R -- "$src" "$dest" 2>/dev/null; then
        info "Backed up: $label"
        return 0
    fi

    warn "Failed to backup: $label"
    return 1
}

# Create backup of existing configuration
create_backup() {
    info "Creating backup of existing configuration..."
    mkdir -p -- "$BACKUP_DIR/.config"

    files_to_backup="
        .bashrc .bash_profile .bash_settings .bash_interactive
        .prompt .profile .zprofile .zshrc .zsh_interactive
        .zsh_settings .aliases .functions .variables
    "
    dirs_to_backup=".vim .fonts scripts .local/share/fonts"
    config_dirs_to_backup="nvim mise kitty sway hypr foot mako facile palette"

    backup_count=0

    for item in $files_to_backup; do
        if backup_item "$HOME/$item" "$BACKUP_DIR/$item" "$item"; then
            backup_count=$((backup_count + 1))
        fi
    done

    for item in $dirs_to_backup; do
        if backup_item "$HOME/$item" "$BACKUP_DIR/$item" "$item"; then
            backup_count=$((backup_count + 1))
        fi
    done

    for item in $config_dirs_to_backup; do
        if backup_item "$HOME/.config/$item" "$BACKUP_DIR/.config/$item" ".config/$item"; then
            backup_count=$((backup_count + 1))
        fi
    done

    if [ "$backup_count" -gt 0 ]; then
        success "Backed up $backup_count items to: $BACKUP_DIR"
    else
        info "No existing configuration files found to backup"
    fi
}

# Link every dotfiles package into $HOME with tido.
#
# tido is the single linker: it links all non-hidden package directories, so
# the installer does not pass a hardcoded list that can drift from the repo.
# `tido update` runs this script and then stops, rather than linking a second
# time on top of it.
install_dotfiles() {
    tido_script="$SOURCE_DIR/scripts/scripts/tido"

    if [ ! -f "$tido_script" ]; then
        error "tido not found in $SOURCE_DIR"
        return 1
    fi

    info "Linking dotfiles with tido..."
    if sh -- "$tido_script" link --target "$HOME" --backup "$BACKUP_DIR"; then
        success "Dotfiles configuration completed"
    else
        error "Dotfiles linking failed"
        return 1
    fi
}

# Locate a CLI on PATH, or in ~/.local/bin (where the installer drops it)
# before the shell has been reloaded and picked up the new PATH.
tool_bin() {
    if command_exists "$1"; then
        command -v "$1"
    elif [ -x "$HOME/.local/bin/$1" ]; then
        printf '%s\n' "$HOME/.local/bin/$1"
    fi
}

mise_bin() {
    tool_bin mise
}

# Install mise, the tool manager that owns ~/.config/mise/config.toml. The
# binary goes into ~/.local/bin, which the shell settings add to PATH.
install_mise() {
    if [ -n "$(mise_bin)" ]; then
        info "mise is already installed"
        return 0
    fi

    if ! command_exists curl && ! command_exists wget; then
        warn "neither curl nor wget available, skipping mise install"
        return 0
    fi

    mkdir -p -- "$HOME/.local/bin"

    info "Installing mise..."
    ok=0
    if command_exists curl; then
        curl -fsSL https://mise.run | MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh >/dev/null 2>&1 && ok=1
    elif command_exists wget; then
        wget -qO- https://mise.run | MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh >/dev/null 2>&1 && ok=1
    fi

    if [ "$ok" -eq 1 ]; then
        export PATH="$HOME/.local/bin:$PATH"
        success "Installed mise into $HOME/.local/bin"
    else
        warn "Failed to install mise"
    fi
}

# Install every tool declared in the mise config (bun, go, python, ...).
# This is by far the slowest step: mise downloads language runtimes and
# CLIs. It is skipped with a warning when mise or the config is missing, and a
# partial failure is not fatal.
install_mise_tools() {
    mise="$(mise_bin)"

    if [ -z "$mise" ]; then
        warn "mise not available, skipping tool installation"
        return 0
    fi

    if [ ! -f "$HOME/.config/mise/config.toml" ]; then
        warn "No mise config at ~/.config/mise/config.toml, skipping tool installation"
        return 0
    fi

    info "Installing mise tools (this can take a while)..."
    if "$mise" install --yes; then
        success "Installed mise tools"
    else
        warn "Some mise tools could not be installed on this platform"
    fi
}

facile_bin() {
    tool_bin facile
}

install_facile() {
    facile="$(facile_bin)"

    if [ -z "$facile" ]; then
        if ! command_exists curl && ! command_exists wget; then
            warn "neither curl nor wget available, skipping facile install"
            return 0
        fi

        mkdir -p -- "$HOME/.local/bin"
        info "Installing facile..."
        ok=0
        if command_exists curl; then
            curl -fsSL https://raw.githubusercontent.com/FacileStudio/facile/main/install.sh | bash >/dev/null 2>&1 && ok=1
        elif command_exists wget; then
            wget -qO- https://raw.githubusercontent.com/FacileStudio/facile/main/install.sh | bash >/dev/null 2>&1 && ok=1
        fi

        if [ "$ok" -eq 1 ]; then
            export PATH="$HOME/.local/bin:$PATH"
            facile="$(facile_bin)"
            success "Installed facile into $HOME/.local/bin"
        else
            warn "Failed to install facile"
            return 0
        fi
    else
        info "facile is already installed"
    fi

    if [ -n "$facile" ]; then
        missing_tools=""
        [ -n "$(tool_bin tiroir)" ] || missing_tools="$missing_tools tiroir"
        [ -n "$(tool_bin palette)" ] || missing_tools="$missing_tools palette"
        if [ -z "$missing_tools" ]; then
            info "facile tools already installed (tiroir, palette)"
        else
            info "Installing facile tools:$missing_tools"
            # shellcheck disable=SC2086
            if "$facile" install $missing_tools; then
                success "Installed facile tools:$missing_tools"
            else
                warn "Some facile tools could not be installed"
            fi
        fi
    fi

    palette_cmd="$(tool_bin palette)"
    palette_cfg="$HOME/.config/palette/config.yml"
    [ -f "$palette_cfg" ] || palette_cfg="$HOME/.palette.yml"
    if [ -n "$palette_cmd" ] && [ -f "$palette_cfg" ]; then
        "$palette_cmd" sync --no-reload >/dev/null 2>&1 || true
    fi
}

# The installer links the zsh configuration but never changes the login shell:
# chsh authenticates over PAM, so it either blocks on a password or fails with
# stdin closed, and BusyBox ships no chsh at all. Setting the shell stays a
# manual step, so point at it once at the end when it is still not done.
warn_login_shell() {
    login_shell="${SHELL:-}"

    if command_exists getent; then
        passwd_entry="$(getent passwd "$(id -un)" 2>/dev/null || true)"
        if [ -n "$passwd_entry" ]; then
            login_shell="${passwd_entry##*:}"
        fi
    fi

    case "$login_shell" in
        */zsh | zsh) return 0 ;;
    esac

    zsh_path="$(command -v zsh 2>/dev/null || true)"
    if [ -z "$zsh_path" ]; then
        warn "zsh is not installed; install it, then set it as your login shell with chsh"
        return 0
    fi

    warn "zsh is not your login shell (current: ${login_shell:-unknown}); run: chsh -s $zsh_path"
}

# Show installation summary
show_summary() {
    printf '\n%bDotfiles installation completed successfully!%b\n\n' "${GREEN}" "${NC}"

    printf '%bInstallation Details:%b\n' "${WHITE}" "${NC}"
    printf '  %b-%b Source:      %s\n' "${CYAN}" "${NC}" "$SOURCE_DIR"
    printf '  %b-%b Backup:      %s\n' "${CYAN}" "${NC}" "$BACKUP_DIR"
    printf '  %b-%b Install time: %s\n' "${CYAN}" "${NC}" "$(date)"

    printf '\n%bManaging the symlinks:%b\n' "${WHITE}" "${NC}"
    printf '  %b-%b Re-link everything:  %btido link%b\n' "${CYAN}" "${NC}" "${YELLOW}" "${NC}"
    printf '  %b-%b Update the config:   %btido update%b\n' "${CYAN}" "${NC}" "${YELLOW}" "${NC}"
    printf '  %b-%b Preview changes:     %btido list%b\n' "${CYAN}" "${NC}" "${YELLOW}" "${NC}"
    printf '  %b-%b Remove a package:    %btido unlink nvim%b\n' "${CYAN}" "${NC}" "${YELLOW}" "${NC}"
    printf '  %b-%b Clean backup files:  %btido clean-backups%b\n' "${CYAN}" "${NC}" "${YELLOW}" "${NC}"

    printf '\n%bNext Steps:%b\n' "${WHITE}" "${NC}"
    printf '  %b1.%b Restart your terminal or run: %bsource ~/.bashrc%b (or ~/.zshrc)\n' "${CYAN}" "${NC}" "${YELLOW}" "${NC}"
    printf '  %b2.%b Install optional GUI apps as needed\n' "${CYAN}" "${NC}"
    printf '  %b3.%b See README for program installation links\n' "${CYAN}" "${NC}"

    warn_login_shell

    printf '\n%bReport issues at:%b\n' "${WHITE}" "${NC}"
    printf '  %bhttps://github.com/saravenpi/dotfiles/issues%b\n' "${BLUE}" "${NC}"
    printf '%b=======================================%b\n' "${WHITE}" "${NC}"

    # `welcome` is an optional command the user may provide; show it when it
    # is on PATH. Never source ~/.functions here: it is a bash file and this
    # script runs under sh + ``set -eu``, where sourcing it aborts the run.
    if command_exists welcome; then
        welcome
    fi
}

# Main installation flow
main() {
    show_banner

    check_dependencies

    # tmux-yank needs a clipboard helper. Distributions almost always ship one,
    # so this only warns about the requirement - the installer never touches the
    # system package manager.
    if ! command_exists pbcopy && ! command_exists wl-copy \
        && ! command_exists xclip && ! command_exists xsel; then
        warn "tmux-yank needs a clipboard helper (wl-clipboard on Wayland, xclip or xsel on X11)"
    fi

    if [ -f /etc/alpine-release ] || (command_exists ldd && ldd --version 2>&1 | grep -qi musl); then
        if [ ! -f /usr/include/linux/errqueue.h ] || ! command_exists cc; then
            warn "musl detected without build essentials; for Node and C/Rust tools, install: apk add build-base linux-headers libgcc libstdc++"
        fi
    fi

    resolve_source
    init_submodules

    printf '\n%bInstalling dotfiles...%b\n' "${YELLOW}" "${NC}"
    printf '%bBackup location: %s%b\n' "${WHITE}" "$BACKUP_DIR" "${NC}"

    create_backup
    install_dotfiles || { error "Dotfiles installation failed"; exit 1; }
    install_mise
    install_mise_tools
    install_facile

    show_summary

    success "Installation completed successfully!"
}

main "$@"
