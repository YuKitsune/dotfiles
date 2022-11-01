#!/usr/bin/env bash

source $PWD/scripts/utils.sh

bootstrap() {
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
}

reboot_prompt() {
    gum confirm "Some changes may require a restart to take effect, do you want to restart now?"
    if [ $? -eq 0 ]
    then
        shutdown -r now
    fi
}

install() {

    # Install brews from the brewfile
    echo "🍺 ♻️ Syncing brews"
    brew bundle

    echo "🍺 🧹 Cleaning up brews"
    brew bundle cleanup --force

    echo "📦 🌏 Installing packages"
    sudo sh ./scripts/packages.sh

    echo "🔑 🔧 Configuring SSH keys"
    sh ./scripts/ssh.sh

    # Install VSCode plugins
    sh ./scripts/vscode.sh sync

    # Configure macOS defaults
    sh ./scripts/macos.sh

    # Create symlinks
    sh ./scripts/symlinks.sh install

    echo "🎉 All done!"
    reboot_prompt
}

update() {

    # Dump brews to brewfile
    echo "🍺 ♻️ Writing brews"
    brew bundle dump --force

    # Dump VSCode plugins to file
    sh ./scripts/vscode.sh update

    echo "👋 All done!"
}

sync() {

    # Update brews to match what's in the file
    echo "🍺 🧹 Cleaning up brews"
    brew bundle --force cleanup

    # Install VSCode plugins
    sh ./scripts/vscode.sh sync

    # Configure macOS defaults
    sh ./scripts/macos.sh

    # Create symlinks
    sh ./scripts/symlinks.sh install

    echo "👋 All done!"
}

uninstall() {

    # Revert symlinks
    sh ./scripts/symlinks.sh uninstall

    # Todo: Uninstall brews
    echo "⚠️ Cannot uninstall brews. Please uninstall them manually."

    echo "👋 All done!"
    reboot_prompt
}

# Ensure pre-requisites are installed (Brew and Gum)
bootstrap

install_command="install"
update_command="update"
sync_command="sync"
uninstall_command="uninstall"

command=$(get_command "$1" $install_command $update_command $sync_command $uninstall_command)
if [ $? -ne 0 ]
then
    echo "👋 Bye!"
    exit 1
fi

if [ $command == $install_command ]
then
    install
elif [ $command == $update_command ]
then
    update
elif [ $command == $sync_command ]
then
    sync
elif [ $command == $uninstall_command ]
then
    uninstall
fi
