#!/usr/bin/env bash

sh ./bootstrap.sh

# Todo: Ask what we want to configure

# Ask for the administrator password upfront
# Todo: Don't ask if we're already sudo
echo "👮‍♀️ Before we can start, we need sudo..."
gum input --password | sudo -vnS

echo "🔗 Creating symlinks..."
./symlinks.sh install

echo "🍎 Configuring macOS..."
./macos/configure.sh

echo "🎉 All done!"

gum confirm "Some changes may require a restart to take effect, do you want to restart now?"
if [ $? -eq 0 ]
then
    shutdown -r now
fi
