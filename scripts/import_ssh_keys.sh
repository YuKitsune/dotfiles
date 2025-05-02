#!/usr/bin/env bash

set -e

source $PWD/scripts/utils.sh

# Set up a trap to catch the interrupt signal and exit the script
trap 'echo "SIGINT detected. Exiting..."; exit 1' SIGINT

echo "🔑 Configuring SSH keys"
echo "✋ Before we try to import SSH keys, ensure the external volume is connected, then press any key to continue..."
read -n 1 key <&1

echo "📁 Please select a directory containing SSH keys"
source_dir=$(gum file --all --directory /)

echo "📁 Sourcing SSH keys from $source_dir"
if [ ! -d "$source_dir" ]; then
    echo "🤷 Source directory not found"
    return 1
fi

# List files only
files=$(ls "$source_dir")

ssh_dir="$HOME/.ssh"
mkdir -p $ssh_dir

for file_name in $files
do
    source_file="$source_dir/$file_name"
    target="$ssh_dir/$file_name"

    if [ -f $target ]
    then
        gum confirm "👯‍♀️ $file_name already exists in $target. Overwrite?"
        if [ $? -eq 1 ]
        then
            echo "🔁 Skipping $file_name"
            continue
        else
            rm $target
        fi
    fi

    echo "📥 Copying \"$source_file\" to \"$target\""
    cp "$source_file" "$target"
    sudo chmod 600 "$target"
done
