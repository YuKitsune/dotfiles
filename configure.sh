#!/usr/bin/env bash

echo "🔗 Creating symlinks..."
sh ./symlinks.sh install

echo "🍎 Configuring macOS..."
sh ./macos.sh

echo "✅ Done!"