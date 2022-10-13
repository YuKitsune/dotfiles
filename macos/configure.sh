#!/usr/bin/env bash

wd=$(dirname "$0")

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# General UI/UX

# Automatically switch between Light and Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle Dark
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Keyboard and Trackpad

# Keyboard: Use F-keys as normal function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Keyboard: Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: Tracking speed
defaults write .GlobalPreferences com.apple.trackpad.scaling 1

# Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# Search engine
/usr/libexec/PlistBuddy -c "Set :\"NSPreferredWebServices\":\"NSWebServicesProviderWebSearch\":\"NSDefaultDisplayName\" DuckDuckGo" $HOME/Library/Preferences/.GlobalPreferences.plist
/usr/libexec/PlistBuddy -c "Set :\"NSPreferredWebServices\":\"NSWebServicesProviderWebSearch\":\"NSProviderIdentifier\" \"com.duckduckgo\"" $HOME/Library/Preferences/.GlobalPreferences.plist

# Audio

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Screen

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Todo: Configure menu bar icons

# Dock
gum spin --show-output --title "Configuring Dock" -- $wd/dock.sh
writeResult Dock

# Finder
gum spin --show-output --title "Configuring Finder" -- $wd/finder.sh
writeResult Finder

# Safari & WebKit
gum spin --show-output --title "Configuring Safari" -- $wd/safari.sh
writeResult Safari

# Activity Monitor

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Disk Utility

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

# Mac App Store

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true


# 3rd Party Applications
gum spin --show-output --title "Configuring Rectangle" -- sh $wd/rectangle.sh
writeResult Rectangle

gum spin --show-output --title "Configuring Stats" -- sh $wd/stats.sh
writeResult Stats

gum spin --show-output --title "Configuring Mos" -- sh $wd/mos.sh
writeResult Mos

# Kill affected applications
for app in "Activity Monitor" \
	"Dock" \
	"Disk Utility" \
	"Finder" \
	"SystemUIServer" \
	"WindowServer"; do
	killall "${app}" &> /dev/null
done
