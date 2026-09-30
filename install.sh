#!/bin/bash
#
# Dotfiles installer.
#
# Clones (or reuses) the dotfiles repository and symlinks every package into
# $HOME using ./stow.sh, a dependency-free replacement for GNU Stow.
# Conflicting files are moved into a timestamped backup directory; nothing is
# deleted during the install.

# Detect if running from pipe/curl and save to temp file for proper execution.
# When piped (curl | bash) BASH_SOURCE is empty, so the script cannot locate
# itself; re-running from a real file keeps source detection working and frees
# stdin from the piped script.
if [ ! -t 0 ] && [ -z "${BASH_SOURCE[0]:-}" ]; then
    TEMP_SCRIPT="$(mktemp /tmp/dotfiles-install-XXXXXX.sh)"
    cat > "$TEMP_SCRIPT"
    chmod +x "$TEMP_SCRIPT"
    if [ -r /dev/tty ]; then
        bash "$TEMP_SCRIPT" "$@" < /dev/tty
    else
        bash "$TEMP_SCRIPT" "$@"
    fi
    rc=$?
    rm -f "$TEMP_SCRIPT"
    exit $rc
fi

# Strict error handling
set -euo pipefail

# Colors for better UI
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Global variables
BACKUP_DIR="$HOME/.config/config.old.$(date +%Y%m%d_%H%M%S)"
readonly BACKUP_DIR
readonly DOTFILES_LINK="$HOME/.dotfiles"
readonly DOTFILES_REPO="https://github.com/saravenpi/dotfiles"
readonly PACKAGES=(fonts kitty nvim shell bash zsh tmux vim mise scripts)

SOURCE_DIR=""

# Logging functions
info() {
    echo -e "${BLUE}::  $*${NC}"
}

success() {
    echo -e "${GREEN}  + $*${NC}"
}

warn() {
    echo -e "${YELLOW}  ! $*${NC}"
}

error() {
    echo -e "${RED}  x $*${NC}"
}

# Welcome message
show_banner() {
    echo -e "${CYAN}"
    echo " /\\_/\\"
    echo "( o.o )"
    echo " > ^ <"
    echo -e "${NC}"
    echo -e "${WHITE}=======================================${NC}"
    echo -e "${WHITE}    Dotfiles Configuration Installer${NC}"
    echo -e "${WHITE}    by @saravenpi${NC}"
    echo -e "${WHITE}=======================================${NC}\n"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check dependencies
check_dependencies() {
    info "Checking dependencies..."

    local missing_deps=()

    command_exists git || missing_deps+=("git")

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        echo -e "\n${YELLOW}Please install the missing dependencies first:${NC}"
        echo -e "${WHITE}See installation instructions at: https://github.com/saravenpi/dotfiles#requirements${NC}"
        exit 1
    fi

    success "All dependencies are installed"
}

# Work out where the dotfiles live. Running from a checkout never clones over
# it; running from a pipe clones into ~/.dotfiles.
resolve_source() {
    local script_dir
    script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

    # 1. A local checkout is authoritative - never touch it with git clone/pull.
    if [[ -f "$script_dir/stow.sh" && -d "$script_dir/nvim" ]]; then
        SOURCE_DIR="$script_dir"
        info "Using local checkout: $SOURCE_DIR"
        ensure_dotfiles_link
        return 0
    fi

    # 2. ~/.dotfiles already linked to a checkout.
    if [[ -L "$DOTFILES_LINK" ]]; then
        local resolved
        resolved="$(readlink -f -- "$DOTFILES_LINK" 2>/dev/null || true)"
        if [[ -n "$resolved" && -d "$resolved" ]]; then
            SOURCE_DIR="$resolved"
            info "Using linked checkout: $DOTFILES_LINK -> $SOURCE_DIR"
            return 0
        fi
        warn "Removing dangling symlink: $DOTFILES_LINK"
        rm -- "$DOTFILES_LINK"
    fi

    # 3. ~/.dotfiles is already a clone - update it in place.
    if [[ -d "$DOTFILES_LINK/.git" ]]; then
        SOURCE_DIR="$DOTFILES_LINK"
        info "Updating existing repository at $SOURCE_DIR"
        if git -C "$SOURCE_DIR" pull --ff-only >/dev/null 2>&1; then
            success "Repository updated"
        else
            warn "Could not update the repository, using the local copy as-is"
        fi
        return 0
    fi

    # 4. Something else lives at ~/.dotfiles - preserve it, then clone.
    if [[ -e "$DOTFILES_LINK" ]]; then
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

# Keep ~/.dotfiles pointing at the checkout that is actually linked into $HOME,
# so there is always a stable path to the repository and stow.sh can be re-run
# from anywhere.
ensure_dotfiles_link() {
    [[ "$SOURCE_DIR" == "$DOTFILES_LINK" ]] && return 0

    if [[ -L "$DOTFILES_LINK" ]]; then
        if [[ "$(readlink -f -- "$DOTFILES_LINK" 2>/dev/null || true)" == "$SOURCE_DIR" ]]; then
            return 0
        fi
        rm -- "$DOTFILES_LINK"
    elif [[ -e "$DOTFILES_LINK" ]]; then
        mkdir -p -- "$BACKUP_DIR"
        mv -- "$DOTFILES_LINK" "$BACKUP_DIR/.dotfiles-pre-existing"
    fi

    ln -s -- "$SOURCE_DIR" "$DOTFILES_LINK"
    success "Linked $DOTFILES_LINK -> $SOURCE_DIR"
}

# Materialize git submodules. The zsh-autosuggestions plugin lives in one, so
# a fresh clone would otherwise be missing it.
init_submodules() {
    [[ -f "$SOURCE_DIR/.gitmodules" ]] || return 0

    if ! git -C "$SOURCE_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        return 0
    fi

    info "Initializing submodules..."
    if git -C "$SOURCE_DIR" submodule update --init --recursive >/dev/null 2>&1; then
        success "Submodules ready"
    else
        warn "Could not initialize submodules"
    fi
}

# Copy one existing item into the backup directory. Symlinks are skipped: they
# are recreated by stow.sh and the link itself carries no data.
backup_item() {
    local src="$1"
    local dest="$2"
    local label="$3"

    [[ -e "$src" ]] || return 1
    [[ -L "$src" ]] && return 1

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

    local files_to_backup=(
        ".bashrc" ".bash_profile" ".bash_settings" ".bash_interactive"
        ".bash_starship" ".zprofile" ".zshrc" ".zsh_interactive"
        ".zsh_settings" ".aliases" ".functions" ".variables" ".tmux.conf"
    )

    local dirs_to_backup=(
        ".vim" ".fonts" "scripts"
    )

    local config_dirs_to_backup=(
        "kitty" "nvim" "mise"
    )

    local backup_count=0
    local item

    # Backup home directory files
    for item in "${files_to_backup[@]}"; do
        if backup_item "$HOME/$item" "$BACKUP_DIR/$item" "$item"; then
            backup_count=$((backup_count + 1))
        fi
    done

    # Backup home directory folders
    for item in "${dirs_to_backup[@]}"; do
        if backup_item "$HOME/$item" "$BACKUP_DIR/$item" "$item"; then
            backup_count=$((backup_count + 1))
        fi
    done

    # Backup config directory folders
    for item in "${config_dirs_to_backup[@]}"; do
        if backup_item "$HOME/.config/$item" "$BACKUP_DIR/.config/$item" ".config/$item"; then
            backup_count=$((backup_count + 1))
        fi
    done

    if [[ $backup_count -gt 0 ]]; then
        success "Backed up $backup_count items to: $BACKUP_DIR"
    else
        info "No existing configuration files found to backup"
    fi
}

# Install dotfiles with stow.sh
install_dotfiles() {
    local stow_script="$SOURCE_DIR/stow.sh"

    if [[ ! -f "$stow_script" ]]; then
        error "stow.sh not found in $SOURCE_DIR"
        return 1
    fi

    local existing_packages=()
    local pkg
    for pkg in "${PACKAGES[@]}"; do
        [[ -d "$SOURCE_DIR/$pkg" ]] && existing_packages+=("$pkg")
    done

    if [[ ${#existing_packages[@]} -eq 0 ]]; then
        error "No packages found in $SOURCE_DIR"
        return 1
    fi

    info "Linking dotfiles with stow.sh..."
    if bash -- "$stow_script" link --target "$HOME" --backup "$BACKUP_DIR" "${existing_packages[@]}"; then
        success "Dotfiles configuration completed"
    else
        error "Dotfiles linking failed"
        return 1
    fi
}

install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    mkdir -p -- "$HOME/.tmux/plugins"

    if [[ -d "$tpm_dir/.git" ]]; then
        info "Updating TPM..."
        if git -C "$tpm_dir" pull --ff-only >/dev/null 2>&1; then
            success "Updated TPM"
        else
            warn "Could not update TPM"
        fi
    else
        info "Installing TPM..."
        if git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir" >/dev/null 2>&1; then
            success "Installed TPM"
        else
            warn "Failed to install TPM"
            return 0
        fi
    fi

    if ! command_exists tmux; then
        warn "tmux not available yet, skipping TPM plugin sync"
        return 0
    fi

    if [[ -x "$tpm_dir/bin/install_plugins" ]]; then
        if "$tpm_dir/bin/install_plugins" >/dev/null 2>&1; then
            success "Installed tmux plugins"
        else
            warn "TPM is installed, but tmux plugins could not be synced automatically"
        fi
    fi
}

# Show installation summary
show_summary() {
    echo -e "\n${GREEN}Dotfiles installation completed successfully!${NC}\n"

    echo -e "${WHITE}Installation Details:${NC}"
    echo -e "  ${CYAN}-${NC} Source:      $SOURCE_DIR"
    echo -e "  ${CYAN}-${NC} Backup:      $BACKUP_DIR"
    echo -e "  ${CYAN}-${NC} Install time: $(date)"

    echo -e "\n${WHITE}Managing the symlinks:${NC}"
    echo -e "  ${CYAN}-${NC} Re-link everything:  ${YELLOW}${SOURCE_DIR}/stow.sh${NC}"
    echo -e "  ${CYAN}-${NC} Preview changes:     ${YELLOW}${SOURCE_DIR}/stow.sh list${NC}"
    echo -e "  ${CYAN}-${NC} Remove a package:    ${YELLOW}${SOURCE_DIR}/stow.sh unlink nvim${NC}"

    echo -e "\n${WHITE}Next Steps:${NC}"
    echo -e "  ${CYAN}1.${NC} Restart your terminal or run: ${YELLOW}source ~/.bashrc${NC} (or ~/.zshrc)"
    echo -e "  ${CYAN}2.${NC} Install optional GUI apps as needed"
    echo -e "  ${CYAN}3.${NC} See README for program installation links"

    echo -e "\n${WHITE}Report issues at:${NC}"
    echo -e "  ${BLUE}https://github.com/saravenpi/dotfiles/issues${NC}"
    echo -e "${WHITE}=======================================${NC}"

    # Call the welcome function if it exists
    if command_exists welcome; then
        welcome
    elif [[ -f "$HOME/.functions" ]]; then
        # shellcheck source=/dev/null
        source "$HOME/.functions" 2>/dev/null || true
        if command_exists welcome; then
            welcome
        fi
    fi
}

# tmux-yank needs a clipboard helper. Distributions almost always ship one, so
# this only checks for it and tells the user what to install when it is missing -
# it never touches the system package manager.
install_clipboard_tool() {
    if command_exists pbcopy || command_exists wl-copy \
        || command_exists xclip || command_exists xsel; then
        success "Clipboard helper available for tmux-yank"
        return 0
    fi

    local pkg
    if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
        pkg="wl-clipboard"
    else
        pkg="xclip"
    fi

    warn "No clipboard helper found; tmux-yank needs '$pkg'"
    local hint="install it with your package manager"
    if command_exists apt-get; then
        hint="sudo apt install $pkg"
    elif command_exists dnf; then
        hint="sudo dnf install $pkg"
    elif command_exists yum; then
        hint="sudo yum install $pkg"
    elif command_exists pacman; then
        hint="sudo pacman -S $pkg"
    elif command_exists zypper; then
        hint="sudo zypper install $pkg"
    elif command_exists apk; then
        hint="sudo apk add $pkg"
    elif command_exists brew; then
        hint="brew install $pkg"
    fi
    echo -e "      ${WHITE}Run: $hint${NC}"
}

# Main installation flow
main() {
    show_banner

    check_dependencies
    install_clipboard_tool

    resolve_source
    init_submodules

    echo -e "\n${YELLOW}Installing dotfiles...${NC}"
    echo -e "${WHITE}Backup location: $BACKUP_DIR${NC}"

    create_backup
    install_dotfiles || { error "Dotfiles installation failed"; exit 1; }
    install_tpm

    show_summary

    success "Installation completed successfully!"
}

# Run main function
main "$@"
