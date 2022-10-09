#!/usr/bin/env bash

install() {

    # Install OhMyZsh
    echo "🐢 Installing OhMyZsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Install p10k
    echo "🔋 Installing Powerlevel10k..."

    ## Download Fonts
    echo "📚 Installing fonts..."
    wget -P ~/Library/Fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget -P ~/Library/Fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget -P ~/Library/Fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget -P ~/Library/Fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

    ## Clone and install with OhMyZsh
    echo "🔋 Cloning Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    echo "✅ Done!"
}

uninstall() {

    # Uninstall OhMyZsh
    echo "🐢 Uninstalling OhMyZsh..."
    zsh | uninstall_oh_my_zsh && exit

    # Uninstall Powerlevel10k (Requires manual intervention)
    echo "⚠️ Powerlevel10k needs to be uninstalled manually: https://github.com/romkatv/powerlevel10k#how-do-i-uninstall-powerlevel10k"
}

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