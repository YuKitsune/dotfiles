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
    echo "✅ Full Disk Access is already granted"
    exit 0
fi

echo "🔒 Full Disk Access is required to configure macOS."
echo "Opening System Settings > Privacy & Security > Full Disk Access..."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"

gum confirm --affirmative="Done" --negative="Skip" "Use \"+\" to add Terminal and Ghostty (from /Applications) and enable Full Disk Access for both, then select \"Done\" to continue."
if [ $? -ne 0 ]
then
    echo "⏭ Skipping. You may need to grant Full Disk Access manually later."
    exit 0
fi

# Full Disk Access only takes effect after the granted app is relaunched, so
# this same script process still won't have it. Stop here instead of letting
# configure.sh continue with a permission that isn't actually active.
echo "⚠️  Full Disk Access only takes effect after Terminal is relaunched."
echo "Quit and reopen Terminal, then run: plz configure"
exit 1
