#!/usr/bin/env bash

echo "🍺 Uninstalling brews..."
sh ./brews.sh uninstall

echo "🖥 Tearing down terminal..."
sh ./terminal.sh uninstall

echo "🔗 Reverting symlinks..."
sh ./symlinks.sh uninstall

echo "✅ Done!"
