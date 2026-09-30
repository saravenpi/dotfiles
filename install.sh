#!/bin/bash
#
# Dotfiles installer.
#
# Reuses (or clones) the dotfiles repository and symlinks every package into
# $HOME using ./scripts/scripts/tido (installed as `tido`), a dependency-free
# replacement for GNU Stow. Conflicting files are moved into a timestamped
# backup directory; nothing is deleted during the install.

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
readonly PACKAGES=(fonts nvim shell bash zsh tmux vim mise scripts)

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

# Work out where the dotfiles live.
#
# A real checkout at ~/.dotfiles is the source of truth: it is used and updated
# in place, and it is never replaced by a symlink. An earlier installer did
# exactly that, moving the user's clone aside and leaving ~/.dotfiles a link.
resolve_source() {
    local script_dir
    script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

    # 1. A real checkout at ~/.dotfiles - the canonical location.
    if [[ -d "$DOTFILES_LINK/.git" && ! -L "$DOTFILES_LINK" ]]; then
        SOURCE_DIR="$DOTFILES_LINK"
        info "Using checkout: $SOURCE_DIR"
        update_repo
        return 0
    fi

    # 2. ~/.dotfiles is a symlink to a checkout (made by an older installer).
    #    Keep working from it, but never create one again.
    if [[ -L "$DOTFILES_LINK" ]]; then
        local resolved
        resolved="$(readlink -f -- "$DOTFILES_LINK" 2>/dev/null || true)"
        if [[ -n "$resolved" && -d "$resolved" ]]; then
            SOURCE_DIR="$resolved"
            warn "$DOTFILES_LINK is a symlink to $SOURCE_DIR; a real clone is preferred"
            return 0
        fi
        warn "Removing dangling symlink: $DOTFILES_LINK"
        rm -- "$DOTFILES_LINK"
    fi

    # 3. Running from a local checkout never clones over it.
    if [[ -f "$script_dir/install.sh" && -d "$script_dir/scripts" ]]; then
        SOURCE_DIR="$script_dir"
        info "Using local checkout: $SOURCE_DIR"
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

# Fast-forward an existing checkout. A failed update is not fatal: the local
# copy is still usable.
update_repo() {
    git -C "$SOURCE_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

    info "Updating repository..."
    if git -C "$SOURCE_DIR" pull --ff-only >/dev/null 2>&1; then
        success "Repository updated"
    else
        warn "Could not update the repository, using the local copy as-is"
    fi
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
# are recreated by tido and the link itself carries no data.
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
        ".prompt" ".zprofile" ".zshrc" ".zsh_interactive"
        ".zsh_settings" ".aliases" ".functions" ".variables" ".tmux.conf"
    )

    local dirs_to_backup=(
        ".vim" ".fonts" "scripts"
    )

    local config_dirs_to_backup=(
        "nvim" "mise"
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

# Install dotfiles with tido
install_dotfiles() {
    local tido_script="$SOURCE_DIR/scripts/scripts/tido"

    if [[ ! -f "$tido_script" ]]; then
        error "tido not found in $SOURCE_DIR"
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

    info "Linking dotfiles with tido..."
    if bash -- "$tido_script" link --target "$HOME" --backup "$BACKUP_DIR" "${existing_packages[@]}"; then
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

# Locate the mise binary: on PATH, or in ~/.local/bin (where the installer
# drops it) before the shell has been reloaded and picked up the new PATH.
mise_bin() {
    if command_exists mise; then
        command -v mise
    elif [[ -x "$HOME/.local/bin/mise" ]]; then
        printf '%s\n' "$HOME/.local/bin/mise"
    fi
}

# Install mise, the tool manager that owns ~/.config/mise/config.toml. The
# binary goes into ~/.local/bin, which the shell settings add to PATH.
install_mise() {
    if [[ -n "$(mise_bin)" ]]; then
        info "mise is already installed"
        return 0
    fi

    if ! command_exists curl; then
        warn "curl not available, skipping mise install"
        return 0
    fi

    mkdir -p -- "$HOME/.local/bin"

    info "Installing mise..."
    if curl -fsSL https://mise.run | MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh >/dev/null 2>&1; then
        success "Installed mise into $HOME/.local/bin"
    else
        warn "Failed to install mise"
    fi
}

# Install every tool declared in the mise config (node, bun, go, ruby, ...).
# This is by far the slowest step: mise downloads language runtimes and
# CLIs. It is skipped with a warning when mise or the config is missing, and a
# partial failure is not fatal.
install_mise_tools() {
    local mise
    mise="$(mise_bin)"

    if [[ -z "$mise" ]]; then
        warn "mise not available, skipping tool installation"
        return 0
    fi

    if [[ ! -f "$HOME/.config/mise/config.toml" ]]; then
        warn "No mise config at ~/.config/mise/config.toml, skipping tool installation"
        return 0
    fi

    info "Installing mise tools (this can take a while)..."
    if "$mise" install >/dev/null 2>&1; then
        success "Installed mise tools"
        # Put the freshly installed shims on PATH so the rest of this script
        # can use the tools without a shell restart.
        eval "$("$mise" activate bash --shims 2>/dev/null || true)"
        bob install latest
    else
        warn "Some mise tools could not be installed; run 'mise install' later"
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
    echo -e "  ${CYAN}-${NC} Re-link everything:  ${YELLOW}tido${NC}"
    echo -e "  ${CYAN}-${NC} Preview changes:     ${YELLOW}tido list${NC}"
    echo -e "  ${CYAN}-${NC} Remove a package:    ${YELLOW}tido unlink nvim${NC}"

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

    resolve_source
    init_submodules

    echo -e "\n${YELLOW}Installing dotfiles...${NC}"
    echo -e "${WHITE}Backup location: $BACKUP_DIR${NC}"

    create_backup
    install_dotfiles || { error "Dotfiles installation failed"; exit 1; }
    install_tpm
    install_mise
    install_mise_tools

    show_summary

    success "Installation completed successfully!"
}

# Run main function
main "$@"
