#!/usr/bin/env bash

# Ask for the administrator password upfront
echo "👮‍♀️ Before we can start, we need sudo..."
sudo -v

echo "🍺 Installing brews..."
./brews.sh install

echo "🖥 Setting up terminal..."
./terminal.sh install

echo "🔗 Creating symlinks..."
./symlinks.sh install

echo "🍎 Configuring macOS..."
./macos.sh

echo "✅ Done! Note that some of these changes require a logout/restart to take effect."
