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

    if [ "$(bw status | jq -r '.status')" = "unauthenticated" ]; then
        echo "🔑 Logging in to Bitwarden..."
        bw login
    fi

    echo "🔑 Unlocking Bitwarden..."
    export BW_SESSION=$(bw unlock --raw)

    if [ -z "$BW_SESSION" ]; then
        echo "❌ Failed to unlock Bitwarden"
        exit 1
    fi

    echo "🔑 Fetching SSH key from Bitwarden..."
    # Item type 5 is "SSH Key"
    items=$(bw list items --session "$BW_SESSION" | jq -c '[.[] | select(.type == 5)]')
    count=$(echo "$items" | jq 'length')

    if [ "$count" -eq 0 ]; then
        echo "❌ No SSH Key items found in Bitwarden"
        exit 1
    fi

    if [ "$count" -gt 1 ]; then
        selected_name=$(echo "$items" | jq -r '.[].name' | gum choose)
        item=$(echo "$items" | jq -c --arg name "$selected_name" '.[] | select(.name == $name)')
    else
        item=$(echo "$items" | jq -c '.[0]')
    fi
    private_key=$(echo "$item" | jq -r '.sshKey.privateKey')
    public_key=$(echo "$item" | jq -r '.sshKey.publicKey')
    write_key "id_ed25519" "$private_key" "$public_key"
}

echo "🔑 Configuring SSH keys"

import_from_bitwarden
