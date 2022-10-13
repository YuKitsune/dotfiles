#!/usr/bin/env bash

sh ./bootstrap.sh

# Ask for the administrator password upfront
echo "👮‍♀️ Before we can start, we need sudo..."
sudo -v

echo "🔗 Creating symlinks..."
./symlinks.sh install

echo "🍎 Configuring macOS..."
./macos.sh

echo "✅ Done! Note that some of these changes require a logout/restart to take effect."
