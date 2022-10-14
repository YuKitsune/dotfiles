#!/usr/bin/env bash

sh ./bootstrap.sh

# Ask for the administrator password upfront
echo "👮‍♀️ Before we can start, we need sudo..."
gum input --placeholder="Password..." --password | sudo -vnS

sh ./macos/brews.sh uninstall
sh ./terminal.sh uninstall
sh ./symlinks.sh uninstall

echo "👋 All done!"

gum confirm "Some changes may require a restart to take effect, do you want to restart now?"
if [ $? -eq 0 ]
then
    shutdown -r now
fi