#!/usr/bin/env bash

source $PWD/utils.sh
source $PWD/macos/defaults.sh

dir=$(dirname "$0")

echo "🍎 Configuring macOS"

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# General UI/UX

# Automatically switch between Light and Dark mode
write_default NSGlobalDomain AppleInterfaceStyle -string Light
write_default NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Expand save panel by default
write_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
write_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Keyboard and Trackpad

# Keyboard: Use F-keys as normal function keys
write_default NSGlobalDomain com.apple.keyboard.fnState -bool true

# Keyboard: Set a blazingly fast keyboard repeat rate
write_default NSGlobalDomain KeyRepeat -int 1
write_default NSGlobalDomain InitialKeyRepeat -int 10

# Trackpad: enable tap to click for this user and for the login screen
write_default com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
write_default NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: Tracking speed
write_default .GlobalPreferences com.apple.trackpad.scaling 1

# Siri
write_default com.apple.assistant.support "Assistant Enabled" -bool false

# Search engine
echo "📝 [.GlobalPreferences] \"NSPreferredWebServices\":\"NSWebServicesProviderWebSearch\":\"NSDefaultDisplayName\" DuckDuckGo"
/usr/libexec/PlistBuddy -c "Set :\"NSPreferredWebServices\":\"NSWebServicesProviderWebSearch\":\"NSDefaultDisplayName\" DuckDuckGo" $HOME/Library/Preferences/.GlobalPreferences.plist

echo "📝 [.GlobalPreferences] \"NSPreferredWebServices\":\"NSWebServicesProviderWebSearch\":\"NSProviderIdentifier\" \"com.duckduckgo\""
/usr/libexec/PlistBuddy -c "Set :\"NSPreferredWebServices\":\"NSWebServicesProviderWebSearch\":\"NSProviderIdentifier\" \"com.duckduckgo\"" $HOME/Library/Preferences/.GlobalPreferences.plist

# Audio

# Increase sound quality for Bluetooth headphones/headsets
write_default com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Screen

# Require password immediately after sleep or screen saver begins
write_default com.apple.screensaver askForPassword -int 1
write_default com.apple.screensaver askForPasswordDelay -int 0

# Disable auto-correct
write_default NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Todo: Configure menu bar icons

# Dock
$dir/dock.sh

# Finder
$dir/finder.sh

# Safari & WebKit
$dir/safari.sh

# Activity Monitor

# Show all processes in Activity Monitor
write_default com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
write_default com.apple.ActivityMonitor SortColumn -string "CPUUsage"
write_default com.apple.ActivityMonitor SortDirection -int 0

# Disk Utility

# Enable the debug menu in Disk Utility
write_default com.apple.DiskUtility DUDebugMenuEnabled -bool true
write_default com.apple.DiskUtility advanced-image-options -bool true

# Mac App Store

# Enable the WebKit Developer Tools in the Mac App Store
write_default com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
write_default com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
write_default com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
write_default com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
write_default com.apple.SoftwareUpdate AutomaticDownload -bool true

# Install System data files & security updates
write_default com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

# Automatically download apps purchased on other Macs
write_default com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
write_default com.apple.commerce AutoUpdate -bool true

# 3rd Party Applications
$dir/rectangle.sh
$dir/stats.sh
$dir/mos.sh

# Kill affected applications
for app in "Activity Monitor" \
	"Disk Utility" \
	"SystemUIServer" \
	"WindowServer"; do
	killall "${app}" &> /dev/null
done
