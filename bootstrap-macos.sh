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

# Update the Command Line Tools if they're behind the OS. A stale version can
# fail to link against a newer SDK (e.g. `ld: tapi error: malformed file` / `unknown architecture`),
# which breaks `cargo install` further down.
echo "Checking for Command Line Tools updates..."
CLT_LABEL=$(softwareupdate --list 2>/dev/null | awk -F': ' '/Label: Command Line Tools/{print $2}' | tail -n1)
if [ -n "$CLT_LABEL" ]; then
    echo "Installing update: $CLT_LABEL"
    sudo softwareupdate --install "$CLT_LABEL"
else
    echo "Command Line Tools are up to date."
fi

# Install Rosetta 2 for macOS on Apple Silicon
if [[ "$(uname -m)" == "arm64" ]]; then
    echo "Checking and installing Rosetta 2..."
    # Not fatal: this can exit non-zero even when there's nothing to do
    # (e.g. Rosetta is already installed), and shouldn't abort the script.
    softwareupdate --install-rosetta --agree-to-license || true
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
else
    echo "Homebrew is already installed."
fi

# Load brew and cargo onto PATH unconditionally, regardless of whether they
# were just installed or already present. Without this, re-running this
# script in a shell that hasn't picked up the updated .zprofile yet would
# make every `command -v` check below fail and re-install/re-compile
# everything from scratch, even though it's already on disk.
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.cargo/bin:$PATH"

# Persist ~/.cargo/bin to .zprofile so `plz` is available in new terminals
# right away. It only lands in the repo-managed .zprofile once
# `plz create-symlinks` runs, but that's part of `plz apply`, which needs
# `plz` on PATH to run at all - so it has to be persisted here too.
CARGO_PATH_LINE='export PATH="$HOME/.cargo/bin:$PATH"'
if ! grep -qF "$CARGO_PATH_LINE" "$HOME/.zprofile" 2>/dev/null; then
    echo "$CARGO_PATH_LINE" >> "$HOME/.zprofile"
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
