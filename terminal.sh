#!/usr/bin/env bash

install() {

    # Install OhMyZsh
    gum spin --show-output --title "Installing OhMyZsh" -- sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    if [ $? -eq 0 ]
    then
        echo "✅ OhMyZsh installed"
    else
        echo "❌ Failed to install OhMyZsh"
    fi

    # Install nerd fonts
    gum spin --show-output --title "Installing MesloLGS NerdFonts" -- wget -P $HOME/Library/Fonts \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    if [ $? -eq 0 ]
    then
        echo "✅ MesloLGS NerdFonts installed"
    else
        echo "❌ Failed to install MesloLGS NerdFonts"
    fi

    ## Clone and install with OhMyZsh
    gum spin --show-output --title "Installing Powerlevel10k" -- git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    if [ $? -eq 0 ]
    then
        echo "✅ Powerlevel10k installed"
    else
        echo "❌ Failed to install Powerlevel10kPowerlevel10k"
    fi
}

uninstall() {

    # Uninstall OhMyZsh
    gum spin --show-output --title "Uninstalling OhMyZsh" -- zsh | uninstall_oh_my_zsh && exit
    echo "🗑 OhMyZsh uninstalled"

    # Uninstall Powerlevel10k (Requires manual intervention)
    echo "⚠️ Powerlevel10k needs to be uninstalled manually: https://github.com/romkatv/powerlevel10k#how-do-i-uninstall-powerlevel10k"
}

if [[ $# -eq 0 ]] ; then
    echo "🛑 Requires at least one argument. Can be either 'install' or 'uninstall'."
    exit 0
fi

command="$1"

if [ $command == "install" ]
then
    install
elif [ $command == "uninstall" ]
then
    uninstall
else
    echo "unsupported argument: '$command'"
    exit 1
fi
