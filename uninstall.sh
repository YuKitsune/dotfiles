#!/usr/bin/env bash

# Ask for the administrator password upfront
echo "👮‍♀️ Before we can start, we need sudo..."
sudo -v

echo "🍺 Uninstalling brews..."
sh ./brews.sh uninstall

echo "🖥 Tearing down terminal..."
sh ./terminal.sh uninstall

echo "🔗 Reverting symlinks..."
sh ./symlinks.sh uninstall

echo "✅ Done! Note that some of these changes require a logout/restart to take effect."
