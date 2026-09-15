#!/usr/bin/env bash

set -e

# Set up a trap to catch the interrupt signal and exit the script
trap 'echo "SIGINT detected. Exiting..."; exit 1' SIGINT

# ~/Library/Safari is owned by the current user, but macOS still blocks
# reading it unless the calling app has been granted Full Disk Access.
# This only reflects the app actually running this script (Terminal), not
# Ghostty, since there's no way to check another app's grant from outside it.
function has_full_disk_access() {
    ls "$HOME/Library/Safari" &> /dev/null
}

if has_full_disk_access; then
    exit 0
fi

echo "🔒 Full Disk Access is required to configure macOS."
echo "Opening System Settings > Privacy & Security > Full Disk Access..."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"

# Full Disk Access only takes effect after the granted app is relaunched, so
# this same script process can't pick it up even if it's granted right now.
# Exit immediately instead of waiting or offering to continue without it.
echo "Use \"+\" to add Terminal and Ghostty (from /Applications) and enable Full Disk Access for both."
echo "⚠️  Then quit and reopen Terminal, and run: plz configure"
exit 1
