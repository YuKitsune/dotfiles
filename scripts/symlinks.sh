#!/usr/bin/env bash

source $PWD/scripts/utils.sh

backup_dir="$HOME/.dotfile_backup/"

install_command="install"
uninstall_command="uninstall"
command=$(get_command "$1" $install_command $uninstall_command)

create_symlink() {
    target="$1"
    source="$2"

    echo "🔗 Linking \"$target\" to \"$source\""

    res=`ln -s "$source" "$target"`
    print_result_if_failed $? "Failed to create link: $res"
}

remove_symlink() {
    echo "🗑 Removing symlink \"$1\""
    rm "$1"
}

create_backup() {
    target="$1"

    # Create the backup directory if it doesn't exist
    if [[ ! -d "$backup_dir" ]]
    then
        mkdir -p "$backup_dir"
    fi

    echo "📀 \"$target\" exists, backing up to \"$backup_dir\""
    mv "$target" "$backup_dir"
}

restore_backup() {
    target="$1"
    file_name="$2"

    backup_file="$backup_dir$file_name"

    echo "♻️ Restoring backup of \"$target\" from \"$backup_file\""
    mv "$backup_file" "$target"
}

run() {
    target="$1"
    file_name="$2"
    link_to="$PWD/$2"

    if [ $command == "$install_command" ]
    then
        # If the destination is already a symlink, skip
        if [ -L "$target" ]
        then
            echo "⏭ \"$target\" is already a symlink, skipping"
            return 0
        fi

        # Create a backup if the destination file exists
        if [ -f "$target" ]
        then
            create_backup "$target"
        fi
        
        # Create the symlink
        create_symlink "$target" "$link_to"
        
    elif [ $command == "$uninstall_command" ]
    then
        # Remove the symlink
        remove_symlink "$target"

        # Restore from backup if a backup exists
        restore_backup "$target" "$file_name"
    fi
}

# Todo: Support backing up multiple files with the same name
action="Creating"
if [ $command == "$uninstall_command" ]
then
    action="Removing"
fi

echo "🔗 $action symlinks"

# Git
run $HOME/.gitconfig .gitconfig
run $HOME/.gitignore .gitignore

# ZSH
run $HOME/.zshrc .zshrc
run $HOME/.p10k.zsh .p10k.zsh
run $HOME/.aliases.zsh .aliases.zsh
run $HOME/.functions.zsh .functions.zsh

# Hyper
run $HOME/.hyper.js .hyper.js

# VSCode
run "$HOME/Library/Application Support/Code/User/settings.json" .vscode.json
