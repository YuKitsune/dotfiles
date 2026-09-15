#!/usr/bin/env bash

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

# Check if the Xcode Command Line Tools are installed.
# Note: `command -v xcode-select` is not a valid check. The `xcode-select`
# binary exists on macOS even before the Command Line Tools are installed.
if ! xcode-select -p &> /dev/null; then
    # Install the Xcode Command Line Tools
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install

    # `xcode-select --install` opens a GUI installer and returns at once.
    # Wait for the install to finish before we use `git`, `brew`, or other
    # tools that need it.
    echo "Waiting for the Xcode Command Line Tools installation to finish..."
    echo "Please complete the steps in the pop-up window."
    until xcode-select -p &> /dev/null; do
        sleep 5
    done
    echo "Xcode Command Line Tools installed."

    sudo xcodebuild -license accept
else
    echo "Xcode Command Line Tools are already installed."
fi

# Install Rosetta 2 for macOS on Apple Silicon
if [[ "$(uname -m)" == "arm64" ]]; then
    echo "Checking and installing Rosetta 2..."
    softwareupdate --install-rosetta --agree-to-license
else
    echo "Not an Apple Silicon system. Skipping Rosetta 2 installation."
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    # Install Homebrew
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    # Persist the Homebrew shell setup to .zprofile so it is available in new
    # terminals right away. Do not wait for `plz create-symlinks` to link
    # the dotfiles .zshrc, as that step runs later, in `plz apply`.
    BREW_SHELLENV_LINE='eval "$(/opt/homebrew/bin/brew shellenv)"'
    if ! grep -qF "$BREW_SHELLENV_LINE" "$HOME/.zprofile" 2>/dev/null; then
        echo "$BREW_SHELLENV_LINE" >> "$HOME/.zprofile"
    fi

    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    # Install gum using Homebrew
    echo "Installing gum..."
    brew install gum
else
    echo "gum is already installed."
fi

# Check if plz is installed
if ! command -v plz &> /dev/null; then
    # plz is installed from source using Cargo, so Rust must be installed first
    if ! command -v cargo &> /dev/null; then
        echo "Installing Rust..."
        brew install rust
    fi

    echo "Installing plz..."
    cargo install --git https://github.com/YuKitsune/plz
else
    echo "plz is already installed."
fi

echo "🚀 You're all set!"
