#!/bin/bash

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
SYMLINKS_FILE="$DOTFILES_DIR/symlinks.yaml"
BACKUP_DIR="$HOME/.dotfile_backup"

mkdir -p "$BACKUP_DIR"

# Process each link using yq
yq '.links[] | .source + "|" + .destination' "$SYMLINKS_FILE" | while IFS='|' read -r source destination; do
    source_path=$(eval echo "$source")
    dest_path=$(eval echo "$destination")
    
    if [[ "$source_path" == ./* ]]; then
        source_path="$DOTFILES_DIR/${source_path#./}"
    fi
    
    [[ ! -e "$source_path" ]] && continue
    
    if [[ -e "$dest_path" ]]; then
        if [[ -L "$dest_path" ]]; then
            current_target=$(readlink "$dest_path")
            [[ "$current_target" == "$source_path" ]] && continue
            rm "$dest_path"
        else
            backup_name="$(basename "$source_path")-backup-$(date +%Y-%m-%d_%H-%M-%S)"
            mv "$dest_path" "$BACKUP_DIR/$backup_name"
        fi
    fi
    
    # Create the parent directory of destination
    mkdir -p "$(dirname "$dest_path")"
    
    ln -sfn "$source_path" "$dest_path"
done