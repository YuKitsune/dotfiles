#!/usr/bin/env bash

source $PWD/utils.sh

install() {
    echo "🖥 Setting up terminal"

    # Install OhMyZsh
    gum spin --show-output --title "Installing OhMyZsh" -- sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    print_result $? "OhMyZsh installed" "Failed to install OhMyZsh"

    # Install nerd fonts
    gum spin --show-output --title "Installing MesloLGS NerdFonts" -- wget -P $HOME/Library/Fonts \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf \
        https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    print_result $? "MesloLGS NerdFonts installed" "Failed to install MesloLGS NerdFonts"

    # Install Powerlevel10k with OhMyZsh
    gum spin --show-output --title "Installing Powerlevel10k" -- git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    print_result $? "Powerlevel10k installed" "Failed to install Powerlevel10k"
}

uninstall() {
    echo "🖥 Tearing down terminal"

    # Uninstall OhMyZsh
    gum spin --show-output --title "Uninstalling OhMyZsh" -- zsh | uninstall_oh_my_zsh && exit
    echo "🗑 OhMyZsh uninstalled"

    # Uninstall Powerlevel10k (Requires manual intervention)
    echo "⚠️ Powerlevel10k needs to be uninstalled manually: https://github.com/romkatv/powerlevel10k#how-do-i-uninstall-powerlevel10k"
}

command=$(get_command "$1" "install" "uninstall")

if [ $command == "install" ]
then
    install
elif [ $command == "uninstall" ]
then
    uninstall
fi
