#!/usr/bin/env bash

source $PWD/utils.sh

command=$(get_command "$1" "install" "uninstall")

action="Installing"
past_tense="installed"
if [ $command == "uninstall" ]
then
    action="Uninstalling"
    past_tense="uninstalled"
fi

echo "🍺 $action brews"
default_command_prefix="🍺"

brew_versions=$(brew list --versions)
home_applications=$(find $HOME/Applications -path '*.app' -maxdepth 5 -print)
applications=$(find /Applications -path '*.app' -maxdepth 5 -print)
all_applications=$home_applications\n$applications

exists() {
    name=$1

    # Check the brew list first
    echo $brew_versions | cut -d " " -f 1 | grep -w $name > /dev/null
    thing_exists=$?
    if [ $thing_exists -eq 0 ]
    then 
        return 0
    fi

    # Fallback to which
    which $name
    thing_exists=$?
    if [ $thing_exists -eq 0 ]
    then 
        return 0
    fi

    # Fallback to applications
    echo $all_applications | grep -i $name > /dev/null
    thing_exists=$?
    if [ $thing_exists -eq 0 ]
    then 
        return 0
    fi

    return 1
}

# Todo: uninstall
install() {
    name=$1
    url=$2
    fileName=$3

    exists $name > /dev/null
    thing_exists=$?

    if [ $thing_exists -eq 0 ] && [ $command == "install" ]
    then
        echo "⏭ $name already installed"
        return 1
    fi

    gum spin --spinner="globe" --show-output --title "Downloading $name" -- curl --output $HOME/Downloads/$fileName $url
    print_result $? "$name downloaded" "Failed to download $name"
    if [ $? -neq 0 ]
    then
        return 1
    fi

    gum spin --show-output --title "Installing $name" -- installer -pkg $HOME/Downloads/$fileName -target /
    print_result $? "$name installed" "Failed to install $name"
    if [ $? -neq 0 ]
    then
        return 1
    fi
}

brew_run() {
    name="$1"
    cask=${2:-0}

    exists $name > /dev/null
    thing_exists=$?

    if [ $thing_exists -eq 0 ] && [ $command == "install" ]
    then
        echo "⏭ $name already installed"
        return 1
    elif [ $thing_exists -eq 1 ] && [ $command == "uninstall" ]
    then
        echo "⏭ $name isn't installed anyway"
        return 1
    fi

    if [ $cask -eq 0 ]
    then
        gum spin --show-output --title "🍺 $action $name" -- brew $command $name
    else
        gum spin --show-output --title "🍺 $action $name" -- brew $command --cask $name
    fi
    
    print_result $? "$name $past_tense" "Failed to $command $name"
}

# Useful commands
brew_run wget
brew_run fortune
brew_run cowsay
brew_run lolcat
brew_run youtube-dl
brew_run watch
brew_run neofetch

# Broken, needs manual download
# brew_run dockutil
install dockutil https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg dockutil-3.0.2.pkg

# Terminal
brew_run hyper 1

# SDKs
brew_run go
brew_run dotnet-sdk 1
brew_run node
brew_run python
brew_run hugo

# Developer Tools
brew_run git
brew_run nvim
brew_run lazygit
brew_run fork
brew_run goland 1
brew_run rider 1
brew_run webstorm 1
brew_run clion 1
brew_run datagrip 1
brew_run visual-studio-code 1
brew_run firefox 1

# DevOps
brew_run act
brew_run gh
brew_run docker
brew_run lazydocker
brew_run minikube
brew_run kubernetes-cli
brew_run helm

# Utilities
brew_run stats
brew_run rectangle 1
brew_run onyx 1
brew_run lulu 1
brew_run mos 1
brew_run bitwarden 1

# Media
brew_run spotify 1
brew_run discord 1

# Optional
# BSD the BSD implementation of xargs doesn't have the -r flag (--no-run-if-empty).
# https://stackoverflow.com/a/17411766
optional_brews=(
    "affinity-photo"
    "affinity-designer"
    "ableton-live-suite"
    "slack"
    "zoom"
    "parallels"
)

gum choose --no-limit ${optional_brews[*]} | xargs -I % brew_run % 1
