#!/usr/bin/env bash

# Set the size of the dock
defaults write com.apple.dock "tilesize" -int "40"

# Enable magnification
defaults write com.apple.dock "magnification" -bool true

# Set the magnification size
defaults write com.apple.dock "largesize" -int "80"

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Setup the dock icons
dockutil --remove all --no-restart
dockutil --add /Applications/Safari.app --no-restart
dockutil --add /Applications/Mail.app --no-restart
dockutil --add /Applications/Calendar.app --no-restart
dockutil --add /Applications/Notes.app --no-restart
dockutil --add /Applications/Reminders.app --no-restart
dockutil --add /Applications/Messages.app --no-restart
dockutil --add /Applications/Discord.app --no-restart
dockutil --add /Applications/Spotify.app --no-restart
dockutil --add /Applications/Hyper.app --no-restart

killall "Dock"
