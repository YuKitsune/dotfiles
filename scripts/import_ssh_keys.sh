#!/usr/bin/env bash

source $PWD/scripts/utils.sh

# Set up a trap to catch the interrupt signal and exit the script
trap 'echo "SIGINT detected. Exiting..."; exit 1' SIGINT

echo "🔑 Configuring SSH keys"
echo "✋ Before we try to import SSH keys, ensure the external volume is connected, then press any key to continue..."
read -n 1 key <&1

# TODO: Let user select .ssh directory instead of volume
echo "🔑 📀 Please select the volume containing your SSH keys:"
volume=$(ls -1 -d -p /Volumes/* | gum choose)
if [ $? -ne 0 ]
then
    echo "🔑 ❌ Failed to select SSH keys volume"
    return 1
fi

echo "🔑 📀 Selected $volume"
# volume=$(echo $volume | sed 's/ /\\ /g') # Escape spaces
source_dir="$volume/.ssh"
if [ ! -d "$source_dir" ]
then
    echo "🔑 ❌ No \".ssh\" directory exists in $volume"
    return 1
fi

echo "🔑 Using $source_dir for SSH keys"

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
