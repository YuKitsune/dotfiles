#!/usr/bin/env bash

set -e

dir=$(dirname "$0")
source "$dir/utils.sh"

# Set up a trap to catch the interrupt signal and exit the script
trap 'echo "SIGINT detected. Exiting..."; exit 1' SIGINT

ssh_dir="$HOME/.ssh"
mkdir -p "$ssh_dir"

function write_key() {
    local name="$1"
    local private_key="$2"
    local public_key="$3"
    local target="$ssh_dir/$name"

    if [ -z "$private_key" ] || [ "$private_key" = "null" ]; then
        echo "❌ $name has no private key, skipping"
        return 1
    fi

    if [ -f "$target" ]; then
        gum confirm "👯‍♀️ $name already exists in $target. Overwrite?"
        if [ $? -ne 0 ]; then
            echo "🔁 Skipping $name"
            return 0
        fi
    fi

    echo "$private_key" > "$target"
    chmod 600 "$target"

    if [ -n "$public_key" ] && [ "$public_key" != "null" ]; then
        echo "$public_key" > "$target.pub"
        chmod 644 "$target.pub"
    fi

    print_result 0 "Wrote $target" "Failed to write $target"
}

function import_from_bitwarden() {
    if ! command -v bw &> /dev/null; then
        echo "❌ Bitwarden CLI (bw) is not installed. Run: plz system apply-packages"
        exit 1
    fi

    echo "🔑 Unlocking Bitwarden..."
    export BW_SESSION=$(bw unlock --raw)

    echo "🔑 Fetching SSH keys from Bitwarden..."
    # Item type 5 is "SSH Key"
    items=$(bw list items --session "$BW_SESSION" | jq -c '.[] | select(.type == 5)')

    if [ -z "$items" ]; then
        echo "❌ No SSH Key items found in Bitwarden"
        exit 1
    fi

    while IFS= read -r item; do
        name=$(echo "$item" | jq -r '.name')
        local_name=$(echo "$name" | tr -c 'A-Za-z0-9_-' '_')
        private_key=$(echo "$item" | jq -r '.sshKey.privateKey')
        public_key=$(echo "$item" | jq -r '.sshKey.publicKey')
        write_key "$local_name" "$private_key" "$public_key"
    done <<< "$items"
}

echo "🔑 Configuring SSH keys"

import_from_bitwarden
