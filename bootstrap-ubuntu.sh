#!/usr/bin/env bash

set -e

# Set the profile.
# This runs first, and without gum, because plz reads .env on every
# invocation. Nothing later in this script should depend on it existing yet.
if [[ -f .env ]]; then
    echo "📄 .env file exists"
else
    echo "🤔 Is this a personal machine, or a work machine?"
    select profile in "personal" "work"; do
        case $profile in
            personal|work) break ;;
            *) echo "Please choose 1 or 2." ;;
        esac
    done
    echo "PROFILE=$profile" > .env
    echo "📄 .env file created"
fi

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install build-essential and basic tools
if ! dpkg -s build-essential &> /dev/null; then
    echo "Installing build-essential..."
    sudo apt-get install -y build-essential curl git wget
else
    echo "build-essential is already installed."
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Installing gum..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt-get update && sudo apt-get install -y gum
else
    echo "gum is already installed."
fi

# Check if plz is installed
if ! command -v plz &> /dev/null; then
    # plz is installed from source using Cargo, so Rust must be installed first
    if ! command -v cargo &> /dev/null; then
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

    echo "Installing plz..."
    cargo install --git https://github.com/YuKitsune/plz
else
    echo "plz is already installed."
fi

echo ""
echo "🚀 Bootstrap complete!"
echo ""
echo "⚠️  Important: Reload your shell to apply PATH changes:"
echo "   Run: exec bash"
echo "   Or open a new terminal window"
echo ""
echo "Then run: plz apply"
