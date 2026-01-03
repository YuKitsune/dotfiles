#!/bin/bash

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
SYMLINKS_FILE="$DOTFILES_DIR/symlinks.yaml"
BACKUP_DIR="$HOME/.dotfile_backup"

# Detect platform
PLATFORM=""
case "$(uname -s)" in
    Darwin*) PLATFORM="darwin" ;;
    Linux*)  PLATFORM="linux" ;;
esac

mkdir -p "$BACKUP_DIR"

process_symlinks() {
    local file="$1"
    [[ ! -f "$file" ]] && return

    yq '.links[] | .source + "|" + .destination' "$file" | while IFS='|' read -r source destination; do
        process_link "$source" "$destination"
    done
}

process_link() {
    local source="$1"
    local destination="$2"

    source_path=$(eval echo "$source")
    dest_path=$(eval echo "$destination")

    if [[ "$source_path" == ./* ]]; then
        source_path="$DOTFILES_DIR/${source_path#./}"
    fi

    [[ ! -e "$source_path" ]] && return

    if [[ -e "$dest_path" ]]; then
        if [[ -L "$dest_path" ]]; then
            current_target=$(readlink "$dest_path")
            [[ "$current_target" == "$source_path" ]] && return
            rm "$dest_path"
        else
            backup_name="$(basename "$source_path")-backup-$(date +%Y-%m-%d_%H-%M-%S)"
            mv "$dest_path" "$BACKUP_DIR/$backup_name"
        fi
    fi
    
    # Create the parent directory of destination
    mkdir -p "$(dirname "$dest_path")"

    ln -sfn "$source_path" "$dest_path"
}

# Process main symlinks file
process_symlinks "$SYMLINKS_FILE"

# Process platform-specific symlinks file
if [[ -n "$PLATFORM" ]]; then
    PLATFORM_SYMLINKS_FILE="$DOTFILES_DIR/$PLATFORM/symlinks.yaml"
    process_symlinks "$PLATFORM_SYMLINKS_FILE"
fi