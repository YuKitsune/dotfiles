#!/usr/bin/env bash

# Todo: Os-specific bootstrapping

which brew > /dev/null
brewExists=$?
if [ $brewExists -ne 0 ]
then
    echo "🍺 Downloading and Installig Brew"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo '# Set PATH, MANPATH, etc., for Homebrew.' >> $HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
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
