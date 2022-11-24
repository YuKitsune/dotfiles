#!/usr/bin/env bash

source $PWD/scripts/utils.sh

extensions_file=$PWD/vscode-extensions.txt

dump_plugins() {
    echo "⌨️ Dumping VSCode Plugins"
    code --list-extensions > $extensions_file
    print_result $? "Extensions file updated" "Failed to update extensions file"
}

apply_plugins() {
    echo "⌨️ Installing VSCode Plugins"
    readarray -t extensions < $extensions_file
    for i in ${extensions[@]}; do
        gum spin --title="Installing $i" --show-output -- code --install-extension $i --force
        print_result $? "$i installed" "Failed install $i"
    done
}

dump_command="dump"
apply_command="apply"

command=$(get_command "$1" "$dump_command" "$apply_command")
if [ $? -ne 0 ]
then
    echo "👋 Bye!"
    exit 1
fi

if [ "$command" == "$dump_command" ]
then
    dump_plugins
elif [ "$command" == "$apply_command" ]
then
    apply_plugins
fi