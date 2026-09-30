#!/usr/bin/env bash
#
# stow.sh - dependency-free replacement for GNU Stow.
#
# Links the contents of each package directory into a target directory
# (default: $HOME). Packages are the non-hidden directories at the root of
# this repository (fonts, kitty, nvim, shell, bash, zsh, tmux, vim, mise,
# scripts); each path inside a package mirrors a path under the target, so
# kitty/.config/kitty/kitty.conf becomes ~/.config/kitty/kitty.conf.
#
# Unlike stow, conflicts never break the run: a real file or directory in
# the way is moved into a timestamped backup directory before the symlink is
# created, and nothing is ever deleted silently.
#
# Usage:
#   ./stow.sh [link]   [options] [package...]   create/refresh symlinks
#   ./stow.sh unlink   [options] [package...]   remove links made by this repo
#   ./stow.sh list     [options] [package...]   dry run, change nothing
#
# Options:
#   -t, --target DIR   directory to link into (default: $HOME)
#   -b, --backup DIR   where conflicting files are moved
#                      (default: <target>/.stow-backups/<timestamp>)
#       --no-backup    refuse to touch conflicting files instead
#   -v, --verbose      also print the source of each link
#   -h, --help         show this help
#
# Examples:
#   ./stow.sh                       # link every package into $HOME
#   ./stow.sh kitty nvim            # link only these packages
#   ./stow.sh list                  # show what would happen
#   ./stow.sh unlink nvim           # remove the nvim symlinks
#
set -euo pipefail

SRC_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

TARGET="${HOME:-}"
ACTION="link"
BACKUP_DIR=""
DO_BACKUP=1
VERBOSE=0
DRY_RUN=0
PACKAGES=()

created=0
backed_up=0
removed=0
conflicts=0

# Newline-separated relative directory paths contributed by more than one
# package (kept as a string so the script still runs on bash 3.2 / macOS).
SHARED_DIRS=""

if [[ -t 1 ]]; then
    C_RED=$'\033[0;31m'; C_GREEN=$'\033[0;32m'; C_YELLOW=$'\033[1;33m'
    C_BLUE=$'\033[0;34m'; C_NC=$'\033[0m'
else
    C_RED=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''; C_NC=''
fi

info() { printf '%s\n' "${C_BLUE}::${C_NC} $*"; }
ok()   { printf '%s\n' "${C_GREEN}  +${C_NC} $*"; }
warn() { printf '%s\n' "${C_YELLOW}  !${C_NC} $*" >&2; }
err()  { printf '%s\n' "${C_RED}  x${C_NC} $*" >&2; }
die()  { err "$*"; exit 1; }

usage() {
    # Print the leading comment block (everything before the first code line).
    awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "${BASH_SOURCE[0]}"
}

# ---------- helpers ---------------------------------------------------------

# Resolve a path lexically, so dangling symlinks resolve too.
resolve() {
    realpath -m -- "$1" 2>/dev/null || printf '%s\n' "$1"
}

# Absolute path of a symlink's destination, even when it does not exist.
link_destination() {
    resolve "$1"
}

is_inside_repo() {
    case "$(resolve "$1")" in
        "$SRC_DIR"/*) return 0 ;;
        *) return 1 ;;
    esac
}

# A directory is "shared" when more than one package contributes content under
# the same relative path (for example .config, owned by kitty, nvim and mise).
# Shared directories must be real directories: folding one package's copy into
# a symlink would shadow every other package using that path.
is_shared_dir() {
    [[ -n "$SHARED_DIRS" ]] || return 1
    printf '%s\n' "$SHARED_DIRS" | grep -Fxq -- "$1"
}

# Precompute the shared directory list for the selected packages.
collect_shared_dirs() {
    SHARED_DIRS="$(
        while IFS= read -r pkg; do
            [[ -n "$pkg" ]] || continue
            while IFS= read -r path; do
                local rel anc
                rel="${path#"$SRC_DIR/$pkg/"}"
                anc="$(dirname -- "$rel")"
                while [[ -n "$anc" && "$anc" != "." ]]; do
                    printf '%s\t%s\n' "$pkg" "$anc"
                    anc="$(dirname -- "$anc")"
                done
            done < <(find "$SRC_DIR/$pkg" -mindepth 1 2>/dev/null)
        done <<< "$1"
    )"
    # Unique package/dir pairs, then keep the dirs claimed by two or more.
    SHARED_DIRS="$(printf '%s\n' "$SHARED_DIRS" | sort -u | cut -f2 | sort | uniq -d)"
}

# Every entry of a directory, hidden files included, as NUL-free lines
# (package contents never contain newlines in practice).
entries() {
    local dir="$1" entry
    shopt -s nullglob dotglob
    for entry in "$dir"/*; do
        printf '%s\n' "$entry"
    done
}

timestamp() { date +%Y%m%d_%H%M%S; }

# Move a conflicting path out of the way, preserving its relative location.
backup_path() {
    local path="$1" rel="$2" dest
    dest="$BACKUP_DIR/$rel"

    if [[ "$DO_BACKUP" -eq 0 ]]; then
        err "conflict: $rel already exists (rerun with --backup to move it aside)"
        return 1
    fi

    if [[ "$DRY_RUN" -eq 1 ]]; then
        ok "would back up: $rel"
        return 0
    fi

    mkdir -p -- "$(dirname -- "$dest")"
    if mv -- "$path" "$dest" 2>/dev/null; then
        backed_up=$((backed_up + 1))
        warn "moved aside: $rel (saved in $BACKUP_DIR)"
        return 0
    fi

    err "could not move aside: $rel"
    return 1
}

create_link() {
    local src="$1" rel="$2" dst
    dst="$TARGET/$rel"

    if [[ "$DRY_RUN" -eq 1 ]]; then
        created=$((created + 1))
        ok "would link: $rel"
        return 0
    fi

    mkdir -p -- "$(dirname -- "$dst")"
    ln -s -- "$(resolve "$src")" "$dst"
    created=$((created + 1))
    if [[ "$VERBOSE" -eq 1 ]]; then
        ok "$rel -> $src"
    else
        ok "$rel"
    fi
}

# Replace a directory symlink that an earlier package created by folding
# (e.g. ~/.config -> kitty/.config) with a real directory of symlinks, so a
# later package can share the same parent path instead of clobbering it.
unfold_directory() {
    local link="$1" rel="$2" old_dest child
    old_dest="$(link_destination "$link")"

    rm -- "$link"
    mkdir -p -- "$link"
    info "unfolded shared directory: $rel"
    while IFS= read -r child; do
        ln -s -- "$(resolve "$child")" "$link/$(basename -- "$child")"
    done < <(entries "$old_dest")
}

# ---------- link / unlink ---------------------------------------------------

link_entry() {
    local src="$1" rel="$2" dst
    dst="$TARGET/$rel"

    # Already one of our symlinks: nothing to do.
    if [[ -L "$dst" ]]; then
        if [[ "$(link_destination "$dst")" == "$(resolve "$src")" ]]; then
            [[ "$VERBOSE" -eq 1 ]] && ok "ok: $rel"
            return 0
        fi

        # A folded directory from an earlier package that shares this path
        # (~/.config is contributed by kitty, nvim and mise). Unfold it into a
        # real directory of symlinks so this package is added alongside the
        # first one instead of replacing it.
        if [[ -d "$src" && -d "$(link_destination "$dst")" ]] && is_inside_repo "$dst"; then
            if [[ "$DRY_RUN" -eq 1 ]]; then
                ok "would unfold shared directory: $rel"
            else
                unfold_directory "$dst" "$rel"
            fi
            local child
            while IFS= read -r child; do
                link_entry "$child" "$rel/$(basename -- "$child")"
            done < <(entries "$src")
            return 0
        fi

        warn "replacing stale symlink: $rel -> $(readlink -- "$dst")"
        backup_path "$dst" "$rel" || { conflicts=$((conflicts + 1)); return 0; }
        create_link "$src" "$rel"
        return 0
    fi

    # A shared directory must stay a real directory so every package gets its
    # own link inside it instead of one folded symlink shadowing the rest.
    if [[ -d "$src" ]] && is_shared_dir "$rel"; then
        if [[ -e "$dst" && ! -d "$dst" ]]; then
            backup_path "$dst" "$rel" || { conflicts=$((conflicts + 1)); return 0; }
        fi
        if [[ "$DRY_RUN" -eq 1 ]]; then
            info "would create directory: $rel"
        else
            mkdir -p -- "$dst"
        fi
        local child
        while IFS= read -r child; do
            link_entry "$child" "$rel/$(basename -- "$child")"
        done < <(entries "$src")
        return 0
    fi

    # A real directory.
    if [[ -d "$dst" ]]; then
        if [[ -d "$src" ]]; then
            # Empty directory where a whole package subtree belongs: fold it
            # into a single symlink. This is what broke previous installs.
            if [[ "$(ls -A -- "$dst" 2>/dev/null)" == "" ]] && ! is_shared_dir "$rel"; then
                [[ "$DRY_RUN" -eq 0 ]] && rmdir -- "$dst"
                create_link "$src" "$rel"
                return 0
            fi

            local child
            while IFS= read -r child; do
                link_entry "$child" "$rel/$(basename -- "$child")"
            done < <(entries "$src")
            return 0
        fi

        backup_path "$dst" "$rel" || { conflicts=$((conflicts + 1)); return 0; }
        create_link "$src" "$rel"
        return 0
    fi

    # A real file (or any other object) is in the way.
    if [[ -e "$dst" ]]; then
        backup_path "$dst" "$rel" || { conflicts=$((conflicts + 1)); return 0; }
        create_link "$src" "$rel"
        return 0
    fi

    create_link "$src" "$rel"
}

unlink_entry() {
    local src="$1" rel="$2" dst
    dst="$TARGET/$rel"

    if [[ -L "$dst" ]]; then
        if is_inside_repo "$dst"; then
            if [[ "$DRY_RUN" -eq 1 ]]; then
                ok "would remove: $rel"
            else
                rm -- "$dst"
                removed=$((removed + 1))
                ok "removed: $rel"
            fi
        else
            warn "left alone (not ours): $rel"
        fi
        return 0
    fi

    if [[ -d "$dst" && -d "$src" ]]; then
        local child
        while IFS= read -r child; do
            unlink_entry "$child" "$rel/$(basename -- "$child")"
        done < <(entries "$src")
        # Clean up directories we emptied and created by walking.
        [[ "$DRY_RUN" -eq 0 ]] && rmdir -- "$dst" 2>/dev/null || true
    fi
}

# ---------- argument handling -----------------------------------------------

while [[ $# -gt 0 ]]; do
    case "$1" in
        link|stow)       ACTION="link" ;;
        unlink|remove|unstow|destow) ACTION="unlink" ;;
        list|dry-run|check) ACTION="link"; DRY_RUN=1 ;;
        -t|--target)     shift; [[ $# -gt 0 ]] || die "--target needs a directory"; TARGET="$1" ;;
        -b|--backup)     shift; [[ $# -gt 0 ]] || die "--backup needs a directory"; BACKUP_DIR="$1" ;;
        --no-backup)     DO_BACKUP=0 ;;
        -v|--verbose)    VERBOSE=1 ;;
        -h|--help)       usage; exit 0 ;;
        --)              shift; while [[ $# -gt 0 ]]; do PACKAGES+=("$1"); shift; done; break ;;
        -*)              die "unknown option: $1 (try --help)" ;;
        *)               PACKAGES+=("$1") ;;
    esac
    shift
done

[[ -n "$TARGET" ]] || die "no target directory (set \$HOME or pass --target)"
[[ -d "$SRC_DIR" ]] || die "cannot find the dotfiles directory"

if [[ -z "$BACKUP_DIR" ]]; then
    BACKUP_DIR="$TARGET/.stow-backups/$(timestamp)"
fi

# Default to every package (non-hidden directory) in the repository.
collect_packages() {
    local entry name
    if [[ ${#PACKAGES[@]} -gt 0 ]]; then
        for name in "${PACKAGES[@]}"; do
            [[ -d "$SRC_DIR/$name" ]] || die "unknown package: $name"
            printf '%s\n' "$name"
        done
        return 0
    fi
    while IFS= read -r entry; do
        name="$(basename -- "$entry")"
        [[ "$name" == .* ]] && continue
        [[ -d "$entry" ]] || continue
        printf '%s\n' "$name"
    done < <(entries "$SRC_DIR")
}

# ---------- run -------------------------------------------------------------

[[ "$DRY_RUN" -eq 0 ]] && mkdir -p -- "$TARGET"

packages="$(collect_packages)"
[[ -n "$packages" ]] || die "no packages found in $SRC_DIR"
collect_shared_dirs "$packages"

case "$ACTION" in
    link)
        [[ "$DRY_RUN" -eq 1 ]] && info "Dry run: nothing will be changed"
        info "Linking into: $TARGET"
        info "Source:       $SRC_DIR"
        ;;
    unlink)
        info "Unlinking from: $TARGET"
        ;;
esac

while IFS= read -r pkg; do
    [[ -n "$pkg" ]] || continue
    while IFS= read -r entry; do
        rel="${entry#"$SRC_DIR/$pkg/"}"
        if [[ "$ACTION" == "unlink" ]]; then
            unlink_entry "$entry" "$rel"
        else
            link_entry "$entry" "$rel"
        fi
    done < <(entries "$SRC_DIR/$pkg")
done <<< "$packages"

printf '\n'
if [[ "$ACTION" == "unlink" ]]; then
    info "Removed $removed link(s)."
else
    info "Linked $created path(s); moved aside $backed_up conflicting path(s)."
    [[ "$backed_up" -gt 0 ]] && info "Backups kept in: $BACKUP_DIR"
fi

if [[ "$conflicts" -gt 0 ]]; then
    err "$conflicts path(s) could not be handled"
    exit 1
fi
