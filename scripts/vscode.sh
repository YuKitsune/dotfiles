#!/usr/bin/env bash

source $PWD/scripts/utils.sh

extensions_file=$PWD/vscode-extensions.txt

update_plugins() {
    echo "⌨️ Updating VSCode Plugins file"
    code --list-extensions > $extensions_file
    print_result $? "Extensions file updated" "Failed to update extensions file"
}

sync_plugins() {
    echo "⌨️ Syncing VSCode Plugins from file"
    readarray -t extensions < $extensions_file
    for i in ${extensions[@]}; do
        gum spin --title="Installing $i" --show-output -- code --install-extension $i --force
        print_result $? "$i installed" "Failed install $i"
    done
}

update_command="update"
sync_command="sync"

command=$(get_command "$1" "$update_command" "$sync_command")
if [ $? -ne 0 ]
then
    echo "👋 Bye!"
    exit 1
fi

if [ "$command" == "$update_command" ]
then
    update_plugins
elif [ "$command" == "$sync_command" ]
then
    sync_plugins
fi