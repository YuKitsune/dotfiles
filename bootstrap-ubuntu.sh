#!/usr/bin/env bash

set -e

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

# Check if task is installed
if ! command -v task &> /dev/null; then
    echo "Installing task..."
    sudo snap install task --classic
else
    echo "task is already installed."
fi

# Set the profile
if [[ -f .env ]]; then
    echo "📄 .env file exists"
else
    echo "🤔 Is this a personal machine, or a work machine?"
    profile=$(gum choose "personal" "work")
    echo "PROFILE=$profile" > .env
    echo "📄 .env file created"
fi

echo ""
echo "🚀 Bootstrap complete!"
echo ""
echo "⚠️  Important: Reload your shell to apply PATH changes:"
echo "   Run: exec bash"
echo "   Or open a new terminal window"
echo ""
echo "Then run: task apply"
