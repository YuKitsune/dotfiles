#!/usr/bin/env bash

source $PWD/utils.sh
source $PWD/macos/defaults.sh

echo "🔍 Configuring Finder"
default_command_prefix="🔍"

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
write_default com.apple.finder QuitMenuItem -bool true

# Set Desktop as the default location for new Finder windows
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
write_default com.apple.finder NewWindowTarget -string 'PfHm'
write_default com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Show icons for hard drives, servers, and removable media on the desktop
write_default com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
write_default com.apple.finder ShowHardDrivesOnDesktop -bool true
write_default com.apple.finder ShowMountedServersOnDesktop -bool true
write_default com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Sidebar sections
write_default com.apple.finder SidebarDevicesSectionDisclosedState -bool true
write_default com.apple.finder SidebarPlacesSectionDisclosedState -bool true
write_default com.apple.finder SidebarShowingSignedIntoiCloud -bool true
write_default com.apple.finder SidebarShowingiCloudDesktop -bool true
write_default com.apple.finder SidebarTagsSctionDisclosedState -bool false

# Show hidden files by default
write_default com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
write_default NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
write_default com.apple.finder FXEnableExtensionChangeWarning -bool false

# Remove trash items after 30 days
write_default com.apple.finder FXRemoveOldTrashItems -bool true

# View Options

# Show status bar
write_default com.apple.finder ShowStatusBar -bool true

# Show path bar
write_default com.apple.finder ShowPathbar -bool true

# Show preview pane
/usr/libexec/PlistBuddy -c "Set :StandardViewOptions:ColumnViewOptions:ColumnShowIcons 1" $HOME/Library/Preferences/com.apple.finder.plist
write_default com.apple.finder ShowPreviewPane -bool true


# Tab Bar
# Show icon and text in the tab bar
/usr/libexec/PlistBuddy -c "Set :\"NSToolbar Configuration Browser\":\"TB Display Mode\" 1" $HOME/Library/Preferences/com.apple.finder.plist

# Avoid creating .DS_Store files on network or USB volumes
write_default com.apple.desktopservices DSDontWriteNetworkStores -bool true
write_default com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
write_default com.apple.finder FXPreferredViewStyle -string "clmv"

# Show the ~/Library folder
chflags nohidden $HOME/Library

# Show the /Volumes folder
chflags nohidden /Volumes

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

kill_process "Finder"
