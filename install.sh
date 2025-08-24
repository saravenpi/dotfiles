#!/bin/bash

# Detect if running from pipe/curl and save to temp file for proper execution
if [ ! -t 0 ] && [ -z "${BASH_SOURCE[0]:-}" ]; then
    # Script is being piped, save to temp and execute
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
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Global variables
readonly LOG_FILE="$HOME/.dotfiles-install.log"
readonly BACKUP_DIR="$HOME/.config/config.old.$(date +%Y%m%d_%H%M%S)"
STEP_COUNT=0
TOTAL_STEPS=8

# Cleanup function for safer exits
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        error "Installation failed with exit code $exit_code"
        error "Check the log file: $LOG_FILE"
        error "Backup location: $BACKUP_DIR"
    fi
    exit $exit_code
}

# Set up cleanup trap
trap cleanup EXIT

# Logging functions
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}ℹ️  $*${NC}" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}✅ $*${NC}" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}⚠️  $*${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}❌ $*${NC}" | tee -a "$LOG_FILE"
}

step() {
    ((STEP_COUNT++))
    echo -e "\n${PURPLE}[Step $STEP_COUNT/$TOTAL_STEPS]${NC} ${CYAN}$*${NC}" | tee -a "$LOG_FILE"
}

# Progress bar function
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((current * width / total))
    local remaining=$((width - completed))

    printf "\r${WHITE}Progress: ["
    printf "%*s" $completed | tr ' ' '='
    printf "%*s" $remaining | tr ' ' '-'
    printf "] %d%% (%d/%d)${NC}" $percentage $current $total
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

# System detection with validation
detect_system() {
    local os_name="$(uname -s)"
    local distro=""

    case "$os_name" in
        Darwin)
            OS="Darwin"
            DISTRO="macOS"
            info "Detected: macOS"
            ;;
        Linux)
            OS="Linux"
            if [[ -f /etc/os-release ]]; then
                distro=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
            elif [[ -f /etc/debian_version ]]; then
                distro="debian"
            elif [[ -f /etc/redhat-release ]]; then
                distro="rhel"
            elif [[ -f /etc/alpine-release ]]; then
                distro="alpine"
            fi

            case "$distro" in
                ubuntu|debian|raspbian) DISTRO="debian" ;;
                fedora|rhel|centos|rocky|almalinux) DISTRO="rhel" ;;
                arch|manjaro|endeavouros) DISTRO="arch" ;;
                void) DISTRO="void" ;;
                alpine) DISTRO="alpine" ;;
                opensuse*|suse*) DISTRO="suse" ;;
                *) DISTRO="unknown" ;;
            esac

            info "Detected: Linux ($distro)"
            ;;
        FreeBSD|OpenBSD|NetBSD)
            OS="BSD"
            DISTRO="bsd"
            info "Detected: BSD variant"
            ;;
        *)
            error "Unsupported operating system: $os_name"
            exit 1
            ;;
    esac

    readonly OS DISTRO
}

# Enhanced command existence check
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if we can write to a directory
can_write_to() {
    [[ -w "$1" ]] || [[ -w "$(dirname "$1")" ]]
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

# URL validation (with timeout for slow connections)
validate_url() {
    local url="$1"
    if curl --output /dev/null --silent --head --fail --connect-timeout 10 --max-time 15 "$url" 2>/dev/null; then
        return 0
    else
        warn "URL validation failed: $url"
        return 1
    fi
}

# Safe command execution with retries
safe_execute() {
    local cmd="$1"
    local description="$2"
    local max_retries="${3:-3}"
    local retry_count=0

    while [[ $retry_count -lt $max_retries ]]; do
        if eval "$cmd" >> "$LOG_FILE" 2>&1; then
            success "$description completed successfully"
            return 0
        else
            ((retry_count++))
            warn "Attempt $retry_count/$max_retries failed for: $description"
            if [[ $retry_count -lt $max_retries ]]; then
                info "Retrying in 2 seconds..."
                sleep 2
            fi
        fi
    done

    error "Failed to execute after $max_retries attempts: $description"
    return 1
}

# Interactive prompt with validation
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
        if [[ -t 0 ]]; then
            read -r response
        else
            read -r response </dev/tty 2>/dev/null || response="$default"
        fi

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

# Pre-flight system checks
preflight_checks() {
    step "Running pre-flight system checks"

    # Check if running as root (not recommended, but allow in containers)
    if [[ $EUID -eq 0 ]]; then
        if [[ -f /.dockerenv ]] || [[ -f /run/.containerenv ]] || [[ "${container:-}" == "docker" ]]; then
            warn "Running as root in a container environment"
        else
            error "This script should not be run as root!"
            error "Please run as a regular user (sudo will be prompted when needed)"
            exit 1
        fi
    fi

    # Check internet connectivity (cross-platform)
    info "Checking internet connectivity..."
    if command_exists curl; then
        if ! curl -s --connect-timeout 5 https://github.com >/dev/null 2>&1; then
            error "No internet connectivity detected"
            error "Please check your network connection and try again"
            exit 1
        fi
    elif command_exists wget; then
        if ! wget -q --timeout=5 --spider https://github.com 2>/dev/null; then
            error "No internet connectivity detected"
            error "Please check your network connection and try again"
            exit 1
        fi
    else
        warn "Cannot verify internet connectivity (curl/wget not found)"
    fi
    success "Internet connectivity verified"

    # Check available disk space (minimum 1GB) - cross-platform
    local available_space
    if [[ "$OS" == "Darwin" ]]; then
        # macOS df shows 512-byte blocks by default
        available_space=$(df "$HOME" | tail -1 | awk '{print $4}')
        # Convert to KB (512-byte blocks / 2)
        available_space=$((available_space / 2))
    else
        # Linux df -k shows KB
        available_space=$(df -k "$HOME" | tail -1 | awk '{print $4}')
    fi
    if [[ $available_space -lt 1048576 ]]; then # 1GB in KB
        warn "Low disk space detected (less than 1GB available)"
        if ! prompt_user "Continue anyway?" "n"; then
            exit 1
        fi
    fi

    # Check if curl or wget is available
    if ! command_exists curl && ! command_exists wget; then
        error "curl or wget is required but not installed"
        error "Please install curl or wget and try again"
        exit 1
    fi

    # Skip URL validation in offline/restricted environments
    if [[ "${SKIP_URL_VALIDATION:-}" != "1" ]]; then
        info "Validating external dependencies..."
        local urls=(
            "https://github.com/saravenpi/dotfiles"
            "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
            "https://sh.rustup.rs"
            "https://starship.rs/install.sh"
        )

        for url in "${urls[@]}"; do
            if ! validate_url "$url"; then
                warn "Could not validate URL: $url"
            fi
        done
    fi

    success "Pre-flight checks completed"
}

# Enhanced dependency installation with error handling
install_dependencies() {
    step "Installing system dependencies"

    case "$OS" in
        Darwin)
            info "Installing dependencies on macOS"
            if ! command_exists brew; then
                info "Installing Homebrew..."
                # Use NONINTERACTIVE mode for automated installation
                if NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> "$LOG_FILE" 2>&1; then
                    # Add Homebrew to PATH for current session (check both ARM and Intel paths)
                    if [[ -f "/opt/homebrew/bin/brew" ]]; then
                        eval "$(/opt/homebrew/bin/brew shellenv)"
                    elif [[ -f "/usr/local/bin/brew" ]]; then
                        eval "$(/usr/local/bin/brew shellenv)"
                    fi
                    success "Homebrew installation completed"
                else
                    error "Failed to install Homebrew"
                    return 1
                fi
            fi

            for pkg in git stow; do
                if ! command_exists "$pkg"; then
                    safe_execute "brew install $pkg" "Installing $pkg"
                fi
            done
            ;;

        Linux)
            info "Installing dependencies on Linux ($DISTRO)"
            case "$DISTRO" in
                debian)
                    # Check if sudo is available
                    if command_exists sudo; then
                        safe_execute "sudo apt-get update" "Updating package lists"
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "sudo apt-get install -y $pkg" "Installing $pkg"
                            fi
                        done
                    else
                        warn "sudo not available, trying as root or with current permissions"
                        safe_execute "apt-get update" "Updating package lists"
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "apt-get install -y $pkg" "Installing $pkg"
                            fi
                        done
                    fi
                    ;;
                rhel)
                    # Check for dnf first (newer Fedora/RHEL), then yum
                    local pkg_manager="yum"
                    if command_exists dnf; then
                        pkg_manager="dnf"
                    fi
                    
                    if command_exists sudo; then
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "sudo $pkg_manager install -y $pkg" "Installing $pkg"
                            fi
                        done
                    else
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "$pkg_manager install -y $pkg" "Installing $pkg"
                            fi
                        done
                    fi
                    ;;
                arch)
                    if command_exists sudo; then
                        # Update package database first
                        safe_execute "sudo pacman -Sy" "Updating package database"
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "sudo pacman -S --noconfirm $pkg" "Installing $pkg"
                            fi
                        done
                    else
                        safe_execute "pacman -Sy" "Updating package database"
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "pacman -S --noconfirm $pkg" "Installing $pkg"
                            fi
                        done
                    fi
                    ;;
                void)
                    if command_exists sudo; then
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "sudo xbps-install -Sy $pkg" "Installing $pkg"
                            fi
                        done
                    else
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "xbps-install -Sy $pkg" "Installing $pkg"
                            fi
                        done
                    fi
                    ;;
                alpine)
                    if command_exists sudo; then
                        safe_execute "sudo apk update" "Updating package lists"
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "sudo apk add $pkg" "Installing $pkg"
                            fi
                        done
                    else
                        safe_execute "apk update" "Updating package lists"
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "apk add $pkg" "Installing $pkg"
                            fi
                        done
                    fi
                    ;;
                suse)
                    if command_exists sudo; then
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "sudo zypper install -y $pkg" "Installing $pkg"
                            fi
                        done
                    else
                        for pkg in git stow; do
                            if ! command_exists "$pkg"; then
                                safe_execute "zypper install -y $pkg" "Installing $pkg"
                            fi
                        done
                    fi
                    ;;
                *)
                    warn "Unknown Linux distribution: $DISTRO"
                    warn "Please ensure git and stow are installed manually"
                    if ! command_exists git || ! command_exists stow; then
                        error "Required dependencies not found"
                        return 1
                    fi
                    ;;
            esac
            ;;
        BSD)
            info "Installing dependencies on BSD"
            if command_exists pkg; then
                for pkg in git stow; do
                    if ! command_exists "$pkg"; then
                        safe_execute "pkg install -y $pkg" "Installing $pkg"
                    fi
                done
            else
                warn "Package manager not found on BSD system"
                warn "Please install git and stow manually"
            fi
            ;;
    esac

    # Final verification
    for cmd in git stow; do
        if ! command_exists "$cmd"; then
            error "Required dependency not found: $cmd"
            return 1
        fi
    done

    success "All dependencies installed successfully"
}

# Safe backup function with verification
create_backup() {
    step "Creating backup of existing configuration"

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

# Safe git clone with validation
safe_git_clone() {
    local repo_url="$1"
    local destination="$2"
    local description="$3"

    info "Cloning $description..."

    # Remove existing directory if it exists
    if [[ -d "$destination" ]]; then
        warn "Directory exists: $destination"
        if [[ "$destination" == "$HOME/.dotfiles" ]]; then
            # For dotfiles specifically, check if it's a git repo
            if [[ -d "$destination/.git" ]]; then
                info "Existing dotfiles repo found, pulling latest changes..."
                if (cd "$destination" && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null); then
                    success "Updated existing dotfiles repository"
                    return 0
                else
                    warn "Could not update existing repo, will clone fresh"
                fi
            fi
        fi
        
        if prompt_user "Remove existing directory and continue?" "y"; then
            # Change to a safe directory before removing destination
            local current_dir="$PWD"
            cd "$HOME" || cd /tmp || cd /
            rm -rf "$destination"
            # Restore original directory if it still exists
            if [[ -d "$current_dir" ]]; then
                cd "$current_dir"
            else
                cd "$HOME"
            fi
        else
            error "Cannot proceed with existing directory"
            return 1
        fi
    fi

    if safe_execute "git clone '$repo_url' '$destination'" "Cloning $description"; then
        success "Successfully cloned $description"
        return 0
    else
        error "Failed to clone $description"
        return 1
    fi
}

# Install dotfiles with stow
install_dotfiles() {
    step "Installing dotfiles configuration"

    # Clone the repository
    if ! safe_git_clone "https://github.com/saravenpi/dotfiles" "$HOME/.dotfiles" "dotfiles repository"; then
        return 1
    fi

    cd "$HOME/.dotfiles" || {
        error "Failed to enter dotfiles directory"
        return 1
    }

    info "Installing configuration with stow..."
    # Handle stow packages more carefully
    local stow_packages=(
        "fonts"
        "i3 dunst scripts picom polybar rofi aerospace"
        "kitty tmux fish bash starship ghostty"
        "nvim vim clang-format emacs"
        "git lazygit kettle"
        "mybins containers"
    )

    for package_group in "${stow_packages[@]}"; do
        # Use --adopt to handle existing files gracefully
        # Also handle multi-word package groups properly
        if safe_execute "stow --adopt $package_group 2>/dev/null || stow $package_group" "Stowing $package_group"; then
            success "Installed: $package_group"
        else
            warn "Failed to install: $package_group (may already exist)"
        fi
    done

    success "Dotfiles configuration installed"
}

# Enhanced program installation with better error handling
install_additional_programs() {
    step "Installing additional programs"

    if ! prompt_user "Install additional programs? (bun, gitmoji-cli, pokemon-colorscripts, starship, tpm, nvim)" "y"; then
        info "Skipping additional programs installation"
        return 0
    fi

    local programs=("bun" "gitmoji-cli" "pokemon-colorscripts" "starship" "tpm" "nvim" "zsh-plugins")
    local current=0
    local total=${#programs[@]}

    for program in "${programs[@]}"; do
        ((current++))
        show_progress $current $total
        install_program "$program"
        echo # New line after progress bar
    done

    success "Additional programs installation completed"
}

# Individual program installation functions
install_program() {
    local program="$1"

    case "$program" in
        bun)
            if [[ -d "$HOME/.bun" ]]; then
                info "bun already installed"
            else
                if safe_execute 'curl -fsSL https://bun.sh/install | bash' "Installing bun"; then
                    export PATH="$HOME/.bun/bin:$PATH"
                fi
            fi
            ;;

        gitmoji-cli)
            if command_exists bun || [[ -x "$HOME/.bun/bin/bun" ]]; then
                local bun_cmd
                bun_cmd=$(command_exists bun && echo "bun" || echo "$HOME/.bun/bin/bun")
                # Try without sudo first, then with sudo if it fails
                if ! safe_execute "$bun_cmd install -g gitmoji-cli" "Installing gitmoji-cli"; then
                    if command_exists sudo; then
                        safe_execute "sudo $bun_cmd install -g gitmoji-cli" "Installing gitmoji-cli with sudo"
                    fi
                fi
            else
                warn "Bun not available, skipping gitmoji-cli"
            fi
            ;;

        pokemon-colorscripts)
            if command_exists pokemon-colorscripts; then
                info "pokemon-colorscripts already installed"
            else
                local temp_dir="/tmp/pokemon-colorscripts-$$"
                if safe_git_clone "https://gitlab.com/phoneybadger/pokemon-colorscripts.git" "$temp_dir" "pokemon-colorscripts"; then
                    if [[ -f "$temp_dir/install.sh" ]]; then
                        chmod +x "$temp_dir/install.sh"
                        if command_exists sudo; then
                            (cd "$temp_dir" && safe_execute "sudo ./install.sh" "Installing pokemon-colorscripts")
                        else
                            (cd "$temp_dir" && safe_execute "./install.sh" "Installing pokemon-colorscripts")
                        fi
                    fi
                    rm -rf "$temp_dir"
                fi
            fi
            ;;

        starship)
            if ! command_exists starship; then
                # Use non-interactive installation
                safe_execute 'curl -sS https://starship.rs/install.sh | sh -s -- -y' "Installing starship"
            else
                info "starship already installed"
            fi
            ;;

        tpm)
            if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
                safe_git_clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm" "tmux plugin manager"
            else
                info "tpm already installed"
            fi
            ;;

        nvim)
            install_neovim
            ;;

        zsh-plugins)
            safe_mkdir "$HOME/.zsh"
            if [[ ! -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
                safe_git_clone "https://github.com/zsh-users/zsh-autosuggestions" "$HOME/.zsh/zsh-autosuggestions" "zsh-autosuggestions"
            else
                info "zsh-autosuggestions already installed"
            fi
            ;;
    esac
}

# Neovim installation with bob
install_neovim() {
    if ! prompt_user "Install Neovim with bob version manager?" "y"; then
        info "Skipping Neovim installation"
        return 0
    fi

    info "Installing Neovim with bob version manager"

    # Install bob if not present
    if ! command_exists bob; then
        install_bob
    fi

    # Add cargo to PATH for Linux
    if [[ "$OS" == "Linux" && ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
        export PATH="$PATH:$HOME/.cargo/bin"
    fi

    # Install eza/exa (modern ls replacement)
    install_ls_replacement

    # Install nightly neovim
    if safe_execute "bob install nightly && bob use nightly" "Installing Neovim nightly"; then
        add_bob_to_shell

        # Verify installation
        if command_exists nvim; then
            local nvim_version
            nvim_version=$(nvim --version | head -n1)
            success "Neovim installation complete! Version: $nvim_version"
            info "Manage versions with: bob list, bob install <ver>, bob use <ver>"
        else
            warn "Neovim verification failed. You may need to restart your shell."
        fi
    fi
}

# Install bob (neovim version manager)
install_bob() {
    case "$OS" in
        Darwin)
            if command_exists brew; then
                safe_execute "brew install bob" "Installing bob via Homebrew"
            else
                warn "Homebrew not found, installing via cargo..."
                install_bob_cargo
            fi
            ;;
        Linux)
            install_bob_cargo
            ;;
        *)
            error "Unsupported OS for bob installation: $OS"
            return 1
            ;;
    esac
}

# Install bob via cargo
install_bob_cargo() {
    if ! command_exists cargo; then
        info "Installing Rust (required for bob)..."
        if safe_execute 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y' "Installing Rust"; then
            if [[ -f "$HOME/.cargo/env" ]]; then
                source "$HOME/.cargo/env"
            fi
        else
            error "Failed to install Rust"
            return 1
        fi
    fi
    safe_execute "cargo install --git https://github.com/MordechaiHadad/bob.git" "Installing bob via cargo"
}

# Add bob to shell configurations
add_bob_to_shell() {
    local bob_path="$HOME/.local/share/bob/nvim-bin"
    local current_shell
    current_shell="$(basename "${SHELL:-}")"

    case "$current_shell" in
        zsh)
            if ! grep -Fq "$bob_path" "$HOME/.zshrc" 2>/dev/null; then
                echo "export PATH=\"\$PATH:$bob_path\"" >> "$HOME/.zshrc"
                info "Added bob path to .zshrc"
            fi
            ;;
        bash)
            if ! grep -Fq "$bob_path" "$HOME/.bashrc" 2>/dev/null; then
                echo "export PATH=\"\$PATH:$bob_path\"" >> "$HOME/.bashrc"
                info "Added bob path to .bashrc"
            fi
            ;;
        fish)
            local fish_config="$HOME/.config/fish/config.fish"
            if [[ -f "$fish_config" ]] && ! grep -Fq "$bob_path" "$fish_config"; then
                echo "set -gx PATH \$PATH $bob_path" >> "$fish_config"
                info "Added bob path to fish config"
            fi
            ;;
        *)
            warn "Unknown shell ($current_shell), adding to both .bashrc and .zshrc"
            for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
                if [[ -f "$rc" ]] && ! grep -Fq "$bob_path" "$rc" 2>/dev/null; then
                    echo "export PATH=\"\$PATH:$bob_path\"" >> "$rc"
                fi
            done
            ;;
    esac

    # Add to current session
    export PATH="$PATH:$bob_path"
}

# Install ls replacement (eza/exa)
install_ls_replacement() {
    case "$OS" in
        Darwin)
            if command_exists brew && ! command_exists eza; then
                safe_execute "brew install eza" "Installing eza"
            fi
            ;;
        Linux)
            if command_exists cargo && ! command_exists exa; then
                safe_execute "cargo install exa" "Installing exa"
            fi
            ;;
    esac
}

# Final verification and cleanup
final_verification() {
    step "Running final verification"

    local critical_commands=("git" "stow")
    local missing_commands=()

    for cmd in "${critical_commands[@]}"; do
        if ! command_exists "$cmd"; then
            missing_commands+=("$cmd")
        fi
    done

    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        error "Critical commands missing: ${missing_commands[*]}"
        return 1
    fi

    # Check if dotfiles directory exists and is properly structured
    if [[ ! -d "$HOME/.dotfiles" ]]; then
        error "Dotfiles directory not found"
        return 1
    fi

    # Verify some key configurations are in place
    local key_configs=("$HOME/.config/nvim" "$HOME/.tmux.conf" "$HOME/.gitconfig")
    local installed_configs=()

    for config in "${key_configs[@]}"; do
        if [[ -e "$config" ]]; then
            installed_configs+=("$(basename "$config")")
        fi
    done

    if [[ ${#installed_configs[@]} -gt 0 ]]; then
        success "Verified configurations: ${installed_configs[*]}"
    fi

    success "Final verification completed"
}

# Show installation summary
show_summary() {
    step "Installation Summary"

    echo -e "\n${GREEN}Dotfiles installation completed successfully!${NC}\n"

    echo -e "${WHITE}Installation Details:${NC}"
    echo -e "  ${CYAN}• System:${NC} $OS ($DISTRO)"
    echo -e "  ${CYAN}• Backup:${NC} $BACKUP_DIR"
    echo -e "  ${CYAN}• Log file:${NC} $LOG_FILE"
    echo -e "  ${CYAN}• Install time:${NC} $(date)"

    echo -e "\n${WHITE}Next Steps:${NC}"
    echo -e "  ${CYAN}1.${NC} Restart your terminal or run: ${YELLOW}source ~/.bashrc${NC} (or ~/.zshrc)"
    echo -e "  ${CYAN}2.${NC} If you installed tmux plugins, press ${YELLOW}prefix + I${NC} in tmux to install them"
    echo -e "  ${CYAN}3.${NC} Configure your shell to use the new prompt"

    if [[ -f "$LOG_FILE" ]]; then
        echo -e "\n${WHITE}Log file available at:${NC} $LOG_FILE"
    fi

    echo -e "\n${WHITE}Report issues at:${NC} ${BLUE}https://github.com/saravenpi/dotfiles/issues${NC}"
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
    # Initialize logging
    echo "Starting dotfiles installation at $(date)" > "$LOG_FILE"

    show_banner

    # System detection
    detect_system

    # Pre-flight checks
    preflight_checks

    # Ask for confirmation before proceeding
    echo -e "\n${YELLOW}This script will backup your current config and install new dotfiles.${NC}"
    echo -e "${WHITE}Backup location: $BACKUP_DIR${NC}"
    
    # In non-interactive mode, proceed automatically
    if [[ "${NONINTERACTIVE:-}" == "1" ]] || [[ "${CI:-}" == "true" ]]; then
        info "Running in non-interactive mode, proceeding with installation"
    elif ! prompt_user "Do you want to proceed with the installation?" "y"; then
        info "Installation cancelled by user"
        exit 0
    fi

    # Run installation steps
    install_dependencies || { error "Dependency installation failed"; exit 1; }
    create_backup || { error "Backup creation failed"; exit 1; }
    install_dotfiles || { error "Dotfiles installation failed"; exit 1; }
    install_additional_programs || { warn "Some additional programs failed to install"; }
    final_verification || { error "Final verification failed"; exit 1; }

    show_summary

    success "Installation completed successfully!"
}

# Run main function
main "$@"
