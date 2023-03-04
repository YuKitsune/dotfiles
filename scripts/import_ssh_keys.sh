#!/usr/bin/env bash

source $PWD/scripts/utils.sh

# Set up a trap to catch the interrupt signal and exit the script
trap 'echo "SIGINT detected. Exiting..."; exit 1' SIGINT

echo "🔑 Configuring SSH keys"
echo "✋ Before we try to import SSH keys, ensure the external volume is connected, then press any key to continue..."
read -n 1 key <&1

echo "😅 Hear me out... I'm gonna show you a file browser, it's going to ask you to select a file. But what I'm actually gonna do is try to import all keys from what ever directory the selected file is in... This is just because the gum command doesn't let you select directories, only files..."
echo "🔑 Please select a file in the directory containing the SSH keys:"
source_dir=$(gum file --all / | xargs dirname)

echo "📁 Sourcing SSH keys from $source_dir"

# List files only
files=$(ls "$source_dir")
ssh_dir="$HOME/.ssh"

for file_name in $files
do
    source_file="$source_dir/$file_name"
    target="$ssh_dir/$file_name"

    if [ -L $target ]
    then
        gum confirm "🔑 👯‍♀️ $file_name already exists in $target. Overwrite?"
        if [ $? -eq 1 ]
        then
            echo "🔑 ⏭ Skipping $file_name"
            continue
        else
            rm $target
        fi
    fi

    if [ -f $target ]
    then
        gum confirm "🔑 👯‍♀️ $file_name already exists in $target. Overwrite?"
        if [ $? -eq 1 ]
        then
            echo "🔑 ⏭ Skipping $file_name"
            continue
        else
            rm $target
        fi
    fi

    echo "🔑 📥 Copying \"$source_file\" to \"$target\""
    cp "$source_file" "$target"
done
