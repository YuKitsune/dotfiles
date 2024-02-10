#!/bin/bash

# Thank you @hmarr!

set -eo pipefail

# Check if the operating system is not macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script is intended to run only on macOS"
    exit 1
fi

icon_path=/Applications/Alacritty.app/Contents/Resources/alacritty.icns
if [ ! -f "$icon_path" ]; then
  echo "Can't find existing icon, make sure Alacritty is installed"
  exit 1
fi

echo "Backing up existing icon"
hash="$(shasum $icon_path | head -c 10)"
mv "$icon_path" "$icon_path.backup-$hash"

echo "Downloading replacement icon"
icon_url=https://github.com/hmarr/dotfiles/files/8549877/alacritty.icns.gz
curl -sL $icon_url | gunzip > "$icon_path"

touch /Applications/Alacritty.app
killall Finder
killall Dock
