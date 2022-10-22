#!/usr/bin/env bash

source $PWD/scripts/utils.sh

brew_versions=$(brew list --versions)
applications=$(find /Applications -path '*.app' -maxdepth 5 -print)

is_installed() {
    for name in "$@"; do

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
        echo $applications | grep -i $name > /dev/null
        thing_exists=$?
        if [ $thing_exists -eq 0 ]
        then 
            return 0
        fi

        return 1
    done
}

install() {
    name=$1
    url=$2
    file_name=$(basename $url)

    is_installed $name > /dev/null
    thing_exists=$?

    if [ $thing_exists -eq 0 ]
    then
        echo "⏭ $name already installed"
        return 0
    fi

    # Todo: Download to temp dir
    gum spin --spinner="globe" --show-output --title "Downloading $name" -- wget -P $HOME/Downloads $url
    print_result $? "$name downloaded" "Failed to download $name"
    if [ $? -ne 0 ]
    then
        return 1
    fi

    gum spin --show-output --title "Installing $name" -- installer -pkg $HOME/Downloads/$file_name -target /
    print_result $? "$name installed" "Failed to install $name"
    if [ $? -ne 0 ]
    then
        return 1
    fi
}

install dockutil https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg
