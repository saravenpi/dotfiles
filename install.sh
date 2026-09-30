#!/bin/bash

# Detect if running from pipe/curl and save to temp file for proper execution
# When piped (curl | bash), stdin is the pipe, not the terminal. Re-execute with
# stdin connected to the real terminal so the confirmation prompt actually asks.
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
IFS=$'\n\t'

# Colors for better UI
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Global variables
readonly BACKUP_DIR="$HOME/.config/config.old.$(date +%Y%m%d_%H%M%S)"
readonly DOTFILES_DIR="$HOME/.dotfiles"
readonly DOTFILES_REPO="https://github.com/saravenpi/dotfiles"

# Logging functions
info() {
    echo -e "${BLUE}ℹ️  $*${NC}"
}

success() {
    echo -e "${GREEN}✅ $*${NC}"
}

warn() {
    echo -e "${YELLOW}⚠️  $*${NC}"
}

error() {
    echo -e "${RED}❌ $*${NC}"
}

# Welcome message
show_banner() {
    echo -e "${CYAN}"
    echo " /\_/\\"
    echo "( o.o )"
    echo " > ^ <"
    echo -e "${NC}"
    echo -e "${WHITE}=======================================${NC}"
    echo -e "${WHITE}    Dotfiles Configuration Installer${NC}"
    echo -e "${WHITE}         by @saravenpi${NC}"
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
    local dep

    for dep in git stow; do
        command_exists "$dep" || missing_deps+=("$dep")
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        echo -e "\n${YELLOW}Please install the missing dependencies first:${NC}"
        echo -e "${WHITE}See installation instructions at: https://github.com/saravenpi/dotfiles#requirements${NC}"
        exit 1
    fi

    success "All dependencies are installed"
}

backup_item() {
    local src="$1"
    local dest="$2"
    local label="$3"

    [[ -e "$src" ]] || return 1
    mkdir -p "$(dirname "$dest")"

    if cp -R "$src" "$dest" 2>/dev/null; then
        info "Backed up: $label"
        return 0
    fi

    warn "Failed to backup: $label"
    return 1
}

# Create backup of existing configuration
create_backup() {
    info "Creating backup of existing configuration..."
    mkdir -p "$BACKUP_DIR/.config"

    local files_to_backup=(
        ".bashrc" ".bash_aliases" ".bash_functions" ".tmux.conf"
        ".clang-format"
    )

    local dirs_to_backup=(
        "fonts" ".dotfiles"
    )

    local config_dirs_to_backup=(
        "kitty" "nvim"
    )

    local backup_count=0
    local item

    # Backup home directory files
    for item in "${files_to_backup[@]}"; do
        backup_item "$HOME/$item" "$BACKUP_DIR/$item" "$item" && ((backup_count++))
    done

    # Backup home directory folders
    for item in "${dirs_to_backup[@]}"; do
        backup_item "$HOME/$item" "$BACKUP_DIR/$item" "$item" && ((backup_count++))
    done

    # Backup config directory folders
    for item in "${config_dirs_to_backup[@]}"; do
        backup_item "$HOME/.config/$item" "$BACKUP_DIR/.config/$item" ".config/$item" && ((backup_count++))
    done

    if [[ $backup_count -gt 0 ]]; then
        success "Backed up $backup_count items to: $BACKUP_DIR"
    else
        info "No existing configuration files found to backup"
    fi
}

# Clone dotfiles repository
clone_dotfiles() {
    info "Setting up dotfiles repository..."

    # Check if dotfiles already exist
    if [[ -d "$DOTFILES_DIR" ]]; then
        warn "Directory exists: $DOTFILES_DIR"
        if [[ -d "$DOTFILES_DIR/.git" ]]; then
            info "Existing dotfiles repo found, pulling latest changes..."
            if (cd "$DOTFILES_DIR" && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null); then
                success "Updated existing dotfiles repository"
                return 0
            else
                warn "Could not update existing repo, will clone fresh"
            fi
        fi

        # Change to safe directory before removing
        cd "$HOME" || cd /tmp || cd /
        rm -rf "$DOTFILES_DIR"
    fi

    info "Cloning dotfiles repository..."
    if git clone "$DOTFILES_REPO" "$DOTFILES_DIR"; then
        success "Successfully cloned dotfiles repository"
        return 0
    else
        error "Failed to clone dotfiles repository"
        return 1
    fi
}

# Install dotfiles with stow
install_dotfiles() {
    info "Installing dotfiles configuration..."

    cd "$DOTFILES_DIR" || {
        error "Failed to enter dotfiles directory"
        return 1
    }

    info "Installing configuration with stow..."

    # Handle stow packages
    local stow_packages=(
        "fonts"
        "kitty tmux shell bash zsh"
        "nvim vim"
        "scripts"
    )

    for package_group in "${stow_packages[@]}"; do
        # First, try to restow (update) existing packages
        if stow --restow $package_group 2>/dev/null; then
            success "Updated: $package_group"
        # If restow fails, try normal stow
        elif stow $package_group 2>/dev/null; then
            success "Installed: $package_group"
        # If both fail, try adopt mode as last resort
        elif stow --adopt $package_group 2>/dev/null; then
            success "Merged: $package_group"
        else
            # Only warn if it truly failed
            warn "Skipped: $package_group (manual intervention may be needed)"
        fi
    done

    success "Dotfiles configuration completed"
}

install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    mkdir -p "$HOME/.tmux/plugins"

    if [[ -d "$tpm_dir/.git" ]]; then
        info "Updating TPM..."
        if git -C "$tpm_dir" pull --ff-only >/dev/null 2>&1; then
            success "Updated TPM"
        else
            warn "Could not update TPM"
        fi
    else
        info "Installing TPM..."
        if git clone https://github.com/tmux-plugins/tpm "$tpm_dir" >/dev/null 2>&1; then
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
    echo -e "  ${CYAN}• Backup:${NC} $BACKUP_DIR"
    echo -e "  ${CYAN}• Install time:${NC} $(date)"

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
    elif [[ -f "$HOME/.bash_functions" ]]; then
        source "$HOME/.bash_functions" 2>/dev/null
        if command_exists welcome; then
            welcome
        fi
    fi
}

# Main installation flow
main() {
    show_banner

    # Check dependencies
    check_dependencies

    echo -e "\n${YELLOW}Installing dotfiles...${NC}"
    echo -e "${WHITE}Backup location: $BACKUP_DIR${NC}"

    # Run installation steps
    create_backup || { error "Backup creation failed"; exit 1; }
    clone_dotfiles || { error "Repository cloning failed"; exit 1; }
    install_dotfiles || { error "Dotfiles installation failed"; exit 1; }
    install_tpm

    show_summary

    success "Installation completed successfully!"
}

# Run main function
main "$@"
