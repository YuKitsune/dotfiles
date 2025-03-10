#!/bin/bash

set -e

FONT_URL="https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"
DMG_FILE_NAME=$(basename $FONT_URL)

TEMP_DIR=$(mktemp -d)
DMG_FILE="$TEMP_DIR/$DMG_FILE_NAME"

# Download the base font
curl -o $DMG_FILE $FONT_URL

# Mount the .dmg file
hdiutil attach "$DMG_FILE"

# Find the mounted volume
DMG_VOLUME=/Volumes/SFMonoFonts

# Locate the .pkg file
PKG_FILE=$(find "$DMG_VOLUME" -name "*.pkg" -type f)
echo "Found .pkg file: $PKG_FILE"

# Check if the .pkg file is found
if [ -z "$PKG_FILE" ]; then
    echo "Error: No .pkg file found in the mounted volume."
    # Unmount the volume before exiting
    hdiutil detach "$DMG_VOLUME"
    exit 1
fi

# Extract the contents of the .pkg file
PKG_EXTRACT_PATH="$TEMP_DIR/extract"
pkgutil --expand-full "$PKG_FILE" "$PKG_EXTRACT_PATH"
echo "Contents of $PKG_FILE extracted into $PKG_EXTRACT_PATH"

# Unmount the volume
hdiutil detach "$DMG_VOLUME"

# Patch the fonts
EXTRACTED_FONTS_PATH="$PKG_EXTRACT_PATH/SFMonoFonts.pkg/Payload/Library/Fonts"
FONTS_DIR="$HOME/Library/Fonts"

docker run --rm \
    -v $EXTRACTED_FONTS_PATH:/in:Z \
    -v $FONTS_DIR:/out:Z \
    nerdfonts/patcher \
    --complete \
    --adjust-line-height \
    --use-single-width-glyphs \
    --careful 
