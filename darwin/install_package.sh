#!/usr/bin/env bash

source ../scripts/utils.sh

brew_versions=$(brew list --versions)
applications=$(find /Applications -path '*.app' -maxdepth 5 -print)

function _package_is_installed() {
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

function _install_package() {
    local usage="\
Usage:
  ${FUNCNAME[0]} <package_name> <package_url>
Sample:
  ${FUNCNAME[0]} dockutil https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg"

    if [[ ${#} -lt 2 ]]
    then
        echo -e "${usage}" > /dev/tty
        return 1
    fi

    name=$1
    url=$2
    file_name=$(basename $url)

    _package_is_installed $name > /dev/null
    thing_exists=$?

    if [ $thing_exists -eq 0 ]
    then
        echo "$name already installed"
        return 0
    fi

    # Todo: Download to temp dir
    gum spin --spinner="globe" --show-output --title "Downloading $name" -- wget -P $HOME/Downloads $url
    print_result $? "$name downloaded" "Failed to download $name"
    if [ $? -ne 0 ]
    then
        return 1
    fi

    gum spin --show-output --title "Installing $name" -- sudo installer -pkg $HOME/Downloads/$file_name -target /
    print_result $? "$name installed" "Failed to install $name"
    if [ $? -ne 0 ]
    then
        return 1
    fi
}

_install_package $@
