#!/usr/bin/env bash

echo "🍺 Installing brews..."
sh ./brews.sh install

echo "🖥 Setting up terminal..."
sh ./terminal.sh install

echo "🔗 Creating symlinks..."
sh ./symlinks.sh install

echo "🍎 Configuring macOS..."
sh ./macos.sh

echo "✅ Done!"