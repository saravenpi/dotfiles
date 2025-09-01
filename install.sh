#!/bin/bash

# Detect if running from pipe/curl and save to temp file for proper execution
if [ ! -t 0 ] && [ -z "${BASH_SOURCE[0]:-}" ]; then
    TEMP_SCRIPT="$(mktemp /tmp/dotfiles-install-XXXXXX.sh)"
    cat > "$TEMP_SCRIPT"
    chmod +x "$TEMP_SCRIPT"
    bash "$TEMP_SCRIPT" "$@"
    rm -f "$TEMP_SCRIPT"
    exit $?
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

# Safe directory creation
safe_mkdir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        if mkdir -p "$dir" 2>/dev/null; then
            info "Created directory: $dir"
            return 0
        else
            error "Failed to create directory: $dir"
            return 1
        fi
    fi
    return 0
}

# Interactive prompt
prompt_user() {
    local message="$1"
    local default="${2:-y}"
    local response

    # Check if running non-interactively
    if [[ ! -t 0 ]] || [[ "${NONINTERACTIVE:-}" == "1" ]]; then
        info "Non-interactive mode: using default ($default) for: $message"
        [[ "$default" == "y" ]]
        return $?
    fi

    while true; do
        echo -e "\n${CYAN}$message${NC}"
        echo -e "${WHITE}[y/N]${NC} (default: $default): "
        read -r response

        # Use default if empty
        response="${response:-$default}"

        case "$response" in
            [yY]|[yY][eE][sS])
                return 0
                ;;
            [nN]|[nN][oO])
                return 1
                ;;
            *)
                warn "Please answer yes or no (y/n)"
                ;;
        esac
    done
}

# Check dependencies
check_dependencies() {
    info "Checking dependencies..."

    local missing_deps=()

    if ! command_exists git; then
        missing_deps+=("git")
    fi

    if ! command_exists stow; then
        missing_deps+=("stow")
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        echo -e "\n${YELLOW}Please install the missing dependencies first:${NC}"
        echo -e "${WHITE}See installation instructions at: https://github.com/saravenpi/dotfiles#requirements${NC}"
        exit 1
    fi

    success "All dependencies are installed"
}

# Create backup of existing configuration
create_backup() {
    info "Creating backup of existing configuration..."

    if ! safe_mkdir "$BACKUP_DIR"; then
        return 1
    fi

    safe_mkdir "$BACKUP_DIR/.config"

    local files_to_backup=(
        ".bashrc" ".bash_aliases" ".bash_functions" ".emacs" ".tmux.conf"
        ".clang-format" ".gitconfig" ".battery-warning.sh" ".currentapp.sh"
        ".desktop.sh" ".menu.sh" ".openchatgpt.sh" ".aerospace.toml"
    )

    local dirs_to_backup=(
        "fonts" ".dotfiles"
    )

    local config_dirs_to_backup=(
        "dunst" "fish" "gtk-3.0" "home-manager" "hyprland" "i3" "kettle"
        "kitty" "lazygit" "nixpkgs" "nvim" "picom" "polybar" "rofi" "ghostty"
    )

    local backup_count=0

    # Backup home directory files
    for file in "${files_to_backup[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            if cp "$HOME/$file" "$BACKUP_DIR/" 2>/dev/null; then
                info "Backed up: $file"
                ((backup_count++))
            else
                warn "Failed to backup: $file"
            fi
        fi
    done

    # Backup home directory folders
    for dir in "${dirs_to_backup[@]}"; do
        if [[ -d "$HOME/$dir" ]]; then
            if cp -r "$HOME/$dir" "$BACKUP_DIR/" 2>/dev/null; then
                info "Backed up: $dir"
                ((backup_count++))
            else
                warn "Failed to backup: $dir"
            fi
        fi
    done

    # Backup config directory folders
    for dir in "${config_dirs_to_backup[@]}"; do
        if [[ -d "$HOME/.config/$dir" ]]; then
            if cp -r "$HOME/.config/$dir" "$BACKUP_DIR/.config/" 2>/dev/null; then
                info "Backed up: .config/$dir"
                ((backup_count++))
            else
                warn "Failed to backup: .config/$dir"
            fi
        fi
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
    if [[ -d "$HOME/.dotfiles" ]]; then
        warn "Directory exists: $HOME/.dotfiles"
        if [[ -d "$HOME/.dotfiles/.git" ]]; then
            info "Existing dotfiles repo found, pulling latest changes..."
            if (cd "$HOME/.dotfiles" && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null); then
                success "Updated existing dotfiles repository"
                return 0
            else
                warn "Could not update existing repo, will clone fresh"
            fi
        fi

        if prompt_user "Remove existing directory and continue?" "y"; then
            # Change to safe directory before removing
            cd "$HOME" || cd /tmp || cd /
            rm -rf "$HOME/.dotfiles"
        else
            error "Cannot proceed with existing directory"
            return 1
        fi
    fi

    info "Cloning dotfiles repository..."
    if git clone "https://github.com/saravenpi/dotfiles" "$HOME/.dotfiles"; then
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

    cd "$HOME/.dotfiles" || {
        error "Failed to enter dotfiles directory"
        return 1
    }

    info "Installing configuration with stow..."

    # Handle stow packages
    local stow_packages=(
        "fonts"
        "i3 dunst scripts picom polybar rofi aerospace"
        "kitty tmux fish bash starship ghostty"
        "nvim vim clang-format emacs"
        "git lazygit kettle"
        "mybins containers"
        "claude"
    )

    for package_group in "${stow_packages[@]}"; do
        # Use --adopt to handle existing files gracefully
        if stow --adopt $package_group 2>/dev/null || stow $package_group 2>/dev/null; then
            success "Installed: $package_group"
        else
            warn "Failed to install: $package_group (may already exist)"
        fi
    done

    success "Dotfiles configuration installed"
}

# Show installation summary
show_summary() {
    echo -e "\n${GREEN}Dotfiles installation completed successfully!${NC}\n"

    echo -e "${WHITE}Installation Details:${NC}"
    echo -e "  ${CYAN}• Backup:${NC} $BACKUP_DIR"
    echo -e "  ${CYAN}• Install time:${NC} $(date)"

    echo -e "\n${WHITE}Next Steps:${NC}"
    echo -e "  ${CYAN}1.${NC} Restart your terminal or run: ${YELLOW}source ~/.bashrc${NC} (or ~/.zshrc)"
    echo -e "  ${CYAN}2.${NC} Install optional programs as needed"
    echo -e "  ${CYAN}3.${NC} See README for program installation links"

    echo -e "\n${WHITE}Optional programs documentation:${NC}"
    echo -e "  ${BLUE}https://github.com/saravenpi/dotfiles#optional-programs${NC}"

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

    # Ask for confirmation before proceeding
    echo -e "\n${YELLOW}This script will backup your current config and install new dotfiles.${NC}"
    echo -e "${WHITE}Backup location: $BACKUP_DIR${NC}"

    # In non-interactive mode, proceed automatically
    if [[ "${NONINTERACTIVE:-}" == "1" ]] || [[ "${CI:-}" == "true" ]]; then
        info "Non-interactive mode: proceeding with installation"
    elif ! prompt_user "Do you want to proceed with the installation?" "y"; then
        info "Installation cancelled by user"
        exit 0
    fi

    # Run installation steps
    create_backup || { error "Backup creation failed"; exit 1; }
    clone_dotfiles || { error "Repository cloning failed"; exit 1; }
    install_dotfiles || { error "Dotfiles installation failed"; exit 1; }

    show_summary

    success "Installation completed successfully!"
}

# Run main function
main "$@"
