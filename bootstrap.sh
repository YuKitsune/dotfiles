#!/usr/bin/env bash

set -e

# Todo: Os-specific bootstrapping

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
echo "🤔 Before we can begin, is this a personal machine, or a work machine?"
profile=$(gum choose "personal" "work")
echo "PROFILE=$profile" > .env
echo "🆕 .env file created"

echo "🚀 You're all set!"
