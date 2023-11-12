#!/usr/bin/env bash

set -e

# macOS: Install xcode tools and 
# xcode-select --install # Todo: this exits with a non-zero code if it's already installed
softwareupdate --install-rosetta

which brew > /dev/null
brewExists=$?
if [ $brewExists -ne 0 ]
then
    echo "🍺 Downloading and Installig Brew"

    # Copied from Installation section of https://brew.sh/
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Copied from the installation instructions shown after installing brew
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Sanity check
    brew doctor
else
    echo "🍺 Brew installed"
fi

# Ensure gum is installed
which gum > /dev/null
gumExists=$?
if [ $gumExists -ne 0 ]
then
    echo "🍬 Downloading and Installig gum"
    brew install gum
else
    echo "🍬 Gum installed"
fi

# Ensure Task is installed
which task > /dev/null
taskExists=$?
if [ $taskExists -ne 0 ]
then
    echo "🏃 Downloading and Installig task"
    brew install go-task
else
    echo "🏃 Task installed"
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
