#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.local/nvim"
BIN_DIR="$HOME/.local/bin"
TMP_DIR="/tmp/nvim-install-$$"

err() { echo -e "❌ $*" >&2; exit 1; }
log() { echo -e "📦 $*" >&2; }

# === Detect OS and architecture ===
OS="$(uname)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin)
    case "$ARCH" in
      x86_64) ASSET="nvim-macos-x86_64.tar.gz" ;;
      arm64) ASSET="nvim-macos-arm64.tar.gz" ;;
      *) err "Unsupported macOS architecture: $ARCH" ;;
    esac
    ;;
  Linux)
    ASSET="nvim-linux64.tar.gz"
    ;;
  *)
    err "Unsupported operating system: $OS"
    ;;
esac

# === Prepare folders ===
mkdir -p "$BIN_DIR"
rm -rf "$TMP_DIR"
mkdir "$TMP_DIR"

# === Clean up previous install ===
if [ -e "$INSTALL_DIR" ]; then
  if [ -L "$INSTALL_DIR" ] || [ -f "$INSTALL_DIR" ]; then
    log "🧹 $INSTALL_DIR is a file or symlink – removing it"
    rm -f "$INSTALL_DIR"
  elif [ -d "$INSTALL_DIR" ]; then
    log "🧹 Removing previous installation at $INSTALL_DIR"
    rm -rf "$INSTALL_DIR"
  fi
fi

# === Download latest Neovim release ===
log "🔍 Fetching latest Neovim version..."
API_URL="https://api.github.com/repos/neovim/neovim/releases/latest"
DOWNLOAD_URL=$(curl -s "$API_URL" | grep "browser_download_url" | grep "$ASSET" | cut -d '"' -f4)

[ -n "$DOWNLOAD_URL" ] || err "Could not find download URL for $ASSET"

log "⬇️ Downloading $ASSET..."
curl -L "$DOWNLOAD_URL" -o "$TMP_DIR/$ASSET"

log "📦 Extracting..."
tar -xzf "$TMP_DIR/$ASSET" -C "$TMP_DIR"
EXTRACTED_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d -name "nvim*" | head -n1)
[ -d "$EXTRACTED_DIR" ] || err "Could not find extracted directory"

log "🚚 Installing to $INSTALL_DIR..."
mv "$EXTRACTED_DIR" "$INSTALL_DIR"

# === Create symlink to ~/.local/bin ===
ln -sf "$INSTALL_DIR/bin/nvim" "$BIN_DIR/nvim"

# === Add ~/.local/bin to PATH if not already ===
add_to_rc() {
  local rc_file="$1"
  local path_line='export PATH="$HOME/.local/bin:$PATH"'
  if [ ! -f "$rc_file" ]; then
    touch "$rc_file"
    log "📄 Created $rc_file"
  fi
  if ! grep -Fxq "$path_line" "$rc_file"; then
    echo "$path_line" >> "$rc_file"
    log "➕ Added to $rc_file: $path_line"
  else
    log "✅ $rc_file already contains the path"
  fi
}

CURRENT_SHELL="$(basename "${SHELL:-}")"
case "$CURRENT_SHELL" in
  zsh) add_to_rc "$HOME/.zshrc" ;;
  bash) add_to_rc "$HOME/.bashrc" ;;
  *)
    log "⚠️ Unrecognized shell ($CURRENT_SHELL), attempting both .bashrc and .zshrc"
    add_to_rc "$HOME/.bashrc"
    add_to_rc "$HOME/.zshrc"
    ;;
esac

# === Clean temp ===
rm -rf "$TMP_DIR"

log "✅ Neovim installed successfully!"
log "💡 Run: nvim --version (you may need to restart your terminal)"

