#!/bin/bash

set -e

echo "==================================="
echo "macOS System Cleanup Script"
echo "==================================="
echo ""

TOTAL_FREED=0

calculate_size() {
    if [ -d "$1" ] || [ -f "$1" ]; then
        du -sk "$1" 2>/dev/null | awk '{print $1}'
    else
        echo "0"
    fi
}

cleanup_dir() {
    local dir="$1"
    local description="$2"

    if [ -d "$dir" ]; then
        local size=$(calculate_size "$dir")
        echo "Cleaning: $description"
        echo "  Location: $dir"
        echo "  Size: $(echo "scale=2; $size/1024/1024" | bc) GB"
        rm -rf "$dir"
        echo "  ✓ Cleaned"
        echo ""
        TOTAL_FREED=$((TOTAL_FREED + size))
    fi
}

cleanup_contents() {
    local dir="$1"
    local description="$2"

    if [ -d "$dir" ]; then
        local size=$(calculate_size "$dir")
        echo "Cleaning: $description"
        echo "  Location: $dir"
        echo "  Size: $(echo "scale=2; $size/1024/1024" | bc) GB"
        rm -rf "$dir"/*
        echo "  ✓ Cleaned"
        echo ""
        TOTAL_FREED=$((TOTAL_FREED + size))
    fi
}

echo "Starting cleanup..."
echo ""

cleanup_contents "$HOME/Library/Caches/Homebrew" "Homebrew cache"
cleanup_contents "$HOME/Library/Caches/go-build" "Go build cache"
cleanup_contents "$HOME/Library/Caches/ms-playwright" "Playwright cache"
cleanup_contents "$HOME/Library/Caches/bun" "Bun cache"
cleanup_contents "$HOME/Library/Caches/mix" "Mix cache"

cleanup_contents "$HOME/.bun/install/cache" "Bun install cache"
cleanup_contents "$HOME/.npm" "npm cache"
cleanup_contents "$HOME/.cache" "Generic cache"

cleanup_contents "$HOME/Library/Logs/DiagnosticReports" "Diagnostic reports"
cleanup_contents "$HOME/Library/Logs/Riot Games" "Riot Games logs"
cleanup_contents "$HOME/Library/Logs/Roblox" "Roblox logs"
cleanup_contents "$HOME/Library/Logs/Homebrew" "Homebrew logs"

cleanup_contents "$HOME/.Trash" "Trash"

echo "==================================="
echo "Optional: Cargo cleanup (safe)"
echo "==================================="
if command -v cargo &> /dev/null; then
    echo "Running cargo clean in home directory..."
    cargo cache --autoclean 2>/dev/null || echo "  cargo-cache not installed, skipping"
    echo ""
fi

echo "==================================="
echo "Cleanup Summary"
echo "==================================="
echo "Total space freed: $(echo "scale=2; $TOTAL_FREED/1024/1024" | bc) GB"
echo ""
echo "Additional recommendations:"
echo "  • Run 'bun pm cache rm' to clear bun cache"
echo "  • Run 'npm cache clean --force' to clear npm cache"
echo "  • Run 'cargo cache --autoclean' if you have cargo-cache installed"
echo "  • Consider cleaning old Rust toolchains in ~/.rustup (1.8GB)"
echo "  • Check nvim plugins in ~/.local/share/nvim (1.4GB)"
echo ""
echo "Done!"
