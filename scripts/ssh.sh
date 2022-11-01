#!/usr/bin/env bash

source $PWD/scripts/utils.sh

import_command="import"
link_command="link"

command=$(get_command "$1" "$import_command" "$link_command")
if [ $? -ne 0 ]
then
    echo "👋 Bye!"
    exit 1
fi

if [ "$command" == "$import_command" ]
then
    echo "🔑 📥 Importing SSH Keys"
elif [ "$command" == "$link_command" ]
then
    echo "🔑 🔗 Linking SSH Keys"
fi

echo "🔑 Please select the directory containing your SSH keys:"
volume=$(ls -1 -d -p /Volumes/* | gum choose)
if [ $? -ne 0 ]
then
    echo "🔑 ❌ Failed to select SSH keys volume"
    exit 1
fi

echo "🔑 Selected $volume"
# volume=$(echo $volume | sed 's/ /\\ /g') # Escape spaces
source_dir="$volume/.ssh"
if [ ! -d "$source_dir" ]
then
    echo "🔑 ❌ No \".ssh\" directory exists in $volume"
    exit 1
fi

echo "🔑 Using $source_dir for SSH keys"
# pushd "$source_dir" > /dev/null

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

    if [ "$command" == "$import_command" ]
    then
        echo "🔑 📥 Copying \"$file\" to \"$target\""
        cp "$source_file" "$target"
    elif [ "$command" == "$link_command" ]
    then
        echo "🔑 🔗 Linking \"$source_file\" to \"$target\""
        ln -s "$source_file" "$target"
    fi
done

# popd > /dev/null
