#!/usr/bin/env bash

# Brew and Gum are necessary before running any other scripts

which bash > /dev/null
brewExists=$?

if [ $brewExists -ne 0 ]
then
    echo "🍺 Downloading and Installig Brew"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "🍺 ✅ Brew installed"
fi

which gum > /dev/null
gumExists=$?

if [ $gumExists -ne 0 ]
then
    echo "🍬 Downloading and Installig gum"
    brew install gum
else
    echo "🍬 ✅ Gum installed"
fi
