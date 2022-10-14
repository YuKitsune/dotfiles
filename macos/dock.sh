#!/usr/bin/env bash

source $PWD/utils.sh
source $PWD/macos/defaults.sh

echo "🚀 Configuring Dock"
default_command_prefix="🚀"

# Set the size of the dock
write_default com.apple.dock "tilesize" -int "40"

# Enable magnification
write_default com.apple.dock "magnification" -bool true

# Set the magnification size
write_default com.apple.dock "largesize" -int "80"

# Show indicator lights for open applications in the Dock
write_default com.apple.dock show-process-indicators -bool true

# Make Dock icons of hidden applications translucent
write_default com.apple.dock showhidden -bool true

add_dock_item() {
    path=$1
    echo "📝 Adding $path to dock" > /dev/tty

    dockutil --add $path --no-restart > /dev/null
    print_result_if_failed $? "Failed to set dock item"
}

# Setup the dock icons
echo "📝 Clearing dock" > /dev/tty
dockutil --remove all --no-restart
add_dock_item /Applications/Safari.app
add_dock_item /System/Applications/Mail.app
add_dock_item /System/Applications/Calendar.app
add_dock_item /System/Applications/Notes.app
add_dock_item /System/Applications/Reminders.app
add_dock_item /System/Applications/Messages.app
add_dock_item /Applications/Discord.app
add_dock_item /Applications/Spotify.app
add_dock_item /Applications/Hyper.app
add_dock_item ~/Downloads

kill_process "Dock"
