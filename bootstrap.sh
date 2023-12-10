#!/usr/bin/env bash

# Check if Xcode Command Line Tools are installed
if ! command -v xcode-select &> /dev/null; then
    # Install Xcode Command Line Tools
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
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

# Check if task is installed
if ! command -v task &> /dev/null; then
    # Install task using Homebrew
    echo "Installing task..."
    brew install task
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

# Test for full disk access
if ! plutil -lint /Library/Preferences/com.apple.TimeMachine.plist >/dev/null; then
  echo "👮 The scripts in this repository require your terminal app to have Full Disk Access. Add this terminal to the Full Disk Access list in System Preferences > Security & Privacy, quit the app, and re-run this script."
  open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
  exit 1
fi

echo "🚀 You're all set!"
