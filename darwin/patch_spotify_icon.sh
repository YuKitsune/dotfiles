#!/bin/bash

set -eo pipefail

icon_path=/Applications/Spotify.app/Contents/Resources/Icon.icns
if [ ! -f "$icon_path" ]; then
  echo "Can't find existing icon, make sure Spotify is installed"
  exit 1
fi

echo "Backing up existing icon"
hash="$(shasum $icon_path | head -c 10)"
mv "$icon_path" "$icon_path.backup-$hash"

echo "Downloading replacement icon"
icon_url=https://github.com/Dav-ej/Custom-Big-Sur-Icons/raw/refs/heads/master/Icons/Spotify_Dark.icns
curl -sL $icon_url > "$icon_path"

touch /Applications/Spotify.app
killall Finder
killall Dock