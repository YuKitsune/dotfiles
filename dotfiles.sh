#!/usr/bin/env bash

source $PWD/scripts/utils.sh

bootstrap() {
    which brew > /dev/null
    brewExists=$?
    if [ $brewExists -ne 0 ]
    then
        echo "๐บ Downloading and Installig Brew"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo '# Set PATH, MANPATH, etc., for Homebrew.' >> $HOME/.zprofile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "๐บ โ Brew installed"
    fi

    which gum > /dev/null
    gumExists=$?
    if [ $gumExists -ne 0 ]
    then
        echo "๐ฌ Downloading and Installig gum"
        brew install gum
    else
        echo "๐ฌ โ Gum installed"
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
    echo "๐บ โป๏ธ Syncing brews"
    brew bundle

    echo "๐บ ๐งน Cleaning up brews"
    brew bundle cleanup --force

    echo "๐ฆ ๐ Installing packages"
    sudo sh ./scripts/packages.sh

    echo "๐ ๐ง Configuring SSH keys"
    sh ./scripts/ssh.sh

    # Install VSCode plugins
    sh ./scripts/vscode.sh sync

    # Configure macOS defaults
    sh ./scripts/macos.sh

    # Create symlinks
    sh ./scripts/symlinks.sh install

    echo "๐ All done!"
    reboot_prompt
}

dump() {

    # Dump brews to brewfile
    echo "๐บ โป๏ธ Writing brews"
    brew bundle dump --force

    # Dump VSCode plugins to file
    sh ./scripts/vscode.sh dump

    echo "๐ All done!"
}

apply() {

    # Update brews to match what's in the file
    echo "๐บ ๐งน Cleaning up brews"
    brew bundle --force cleanup

    echo "๐ ๐ง Configuring SSH keys"
    sh ./scripts/ssh.sh

    # Install VSCode plugins
    sh ./scripts/vscode.sh apply

    # Configure macOS defaults
    sh ./scripts/macos.sh

    # Create symlinks
    sh ./scripts/symlinks.sh install

    echo "๐ All done!"
}

uninstall() {

    # Revert symlinks
    sh ./scripts/symlinks.sh uninstall

    # Todo: Uninstall brews
    echo "โ?๏ธ Cannot uninstall brews. Please uninstall them manually."

    echo "๐ All done!"
    reboot_prompt
}

# Ensure pre-requisites are installed (Brew and Gum)
bootstrap

install_command="install"
dump_command="dump"
apply_command="apply"
uninstall_command="uninstall"

command=$(get_command "$1" $install_command $dump_command $apply_command $uninstall_command)
if [ $? -ne 0 ]
then
    echo "๐ Bye!"
    exit 1
fi

if [ $command == $install_command ]
then
    install
elif [ $command == $dump_command ]
then
    dump
elif [ $command == $apply_command ]
then
    apply
elif [ $command == $uninstall_command ]
then
    uninstall
fi
