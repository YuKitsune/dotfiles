#!/usr/bin/env bash

write_default() {
    local usage="\
Usage:
  ${FUNCNAME[0]} <domain> <key> <type> <value>
Sample:
  ${FUNCNAME[0]} NSGlobalDomain AppleInterfaceStyle -string Light"

    if [[ ${#} -lt 4 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    domain=$1
    key=$2
    type=$3
    value=$4

    echo "📝 [$domain] $key $value" > /dev/tty
    defaults write $domain "$key" $type $value
}

ensure_onboarding_completed() {
    local usage="\
Usage:
  ${FUNCNAME[0]} <domain> <name> <path>
Sample:
  ${FUNCNAME[0]} \"com.caldis.Mos\" \"Mos\" \"/Applications/Mos.app\""

    if [[ ${#} -lt 3 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    domain=$1
    name=$2
    path=$3

    defaults read $domain > /dev/null

    if [ $? == 1 ]
    then
        gum confirm --affirmative="Open" --negative="Skip" "$name has not yet been run. $name has some onboarding steps which may need to be completed before the defaults can be set. Do you wish to open $name now?"

        if [ $? == 0 ]
        then
            open $path
            gum confirm --affirmative="Continue" --negative="Cancel" "$name has been opened, select \"Continue\" once onboarding has been completed."
            if [ $? == 0 ]
            then
                echo "⏭ Skipping $name configuration"
                return 0
            fi
        fi

        echo "⏭ Skipping $name configuration"
        return 1
    fi

    return 0
}

kill_process() {
    name=$1
    pgrep $name > /dev/null
    if [ $? -eq 0 ]
    then
        echo "🔫 Killing $name" > /dev/tty
        killall "$name"
    fi
}

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
write_default .GlobalPreferences com.apple.trackpad.scaling -int 1

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

# Finder

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

# Safari & WebKit

# Privacy: don’t send search queries to Apple
write_default com.apple.Safari UniversalSearchEnabled -bool false
write_default com.apple.Safari SuppressSearchSuggestions -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
write_default com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
write_default com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s bookmarks bar by default
write_default com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari’s sidebar in Top Sites
write_default com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
write_default com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
write_default com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
write_default com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
write_default com.apple.Safari ProxiesInBookmarksBar -string "()"

# Enable the Develop menu and the Web Inspector in Safari
write_default com.apple.Safari IncludeDevelopMenu -bool true
write_default com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
write_default com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
write_default NSGlobalDomain WebKitDeveloperExtras -bool true

# Disable AutoFill
write_default com.apple.Safari AutoFillFromAddressBook -bool false
write_default com.apple.Safari AutoFillPasswords -bool false
write_default com.apple.Safari AutoFillCreditCardData -bool false
write_default com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
write_default com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable plug-ins
write_default com.apple.Safari WebKitPluginsEnabled -bool false
write_default com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Disable Java
write_default com.apple.Safari WebKitJavaEnabled -bool false
write_default com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
write_default com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

# Block pop-up windows
write_default com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
write_default com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Enable “Do Not Track”
write_default com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
write_default com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

kill_process "Safari"

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

# Mos

# Ensure onboarding has been completed before writing defaults
ensure_onboarding_completed com.caldis.Mos Mos /Applications/Mos.app
if [ $? == 1 ]
then
    exit 1
fi

# Prevent the mos settings from messing this up
kill_process "Mos"

# Hide menu bar icon
write_default com.caldis.Mos hideStatusItem -bool true

# Stats

# Ensure onboarding has been completed before writing defaults
ensure_onboarding_completed eu.exelban.Stats Stats /Applications/Stats.app
if [ $? == 1 ]
then
    exit 1
fi

# Prevent the stats settings from messing this up
kill_process "Stats"

# Run on login
write_default eu.exelban.Stats runAtLoginInitialized -bool true

# Don't show in the dock
write_default eu.exelban.Stats dockIcon -bool false

# Only show relevant stats
write_default eu.exelban.Stats CPU_state -bool true
write_default eu.exelban.Stats GPU_state -bool true
write_default eu.exelban.Stats RAM_state -bool true
write_default eu.exelban.Stats Network_state -bool true
write_default eu.exelban.Stats Sensors_state -bool false
write_default eu.exelban.Stats Disk_state -bool false
write_default eu.exelban.Stats Battery_state -bool false

# Configure CPU stats
write_default eu.exelban.Stats "CPU_barChart_position" -int "3"
write_default eu.exelban.Stats "CPU_label_position" -int "1"
write_default eu.exelban.Stats "CPU_lineChart_position" -int "0"
write_default eu.exelban.Stats "CPU_line_chart_box" -bool false
write_default eu.exelban.Stats "CPU_line_chart_frame" -bool true
write_default eu.exelban.Stats "CPU_line_chart_label" -bool true
write_default eu.exelban.Stats "CPU_line_chart_value" -bool false
write_default eu.exelban.Stats "CPU_line_chart_valueColor" -bool false
write_default eu.exelban.Stats "CPU_mini_position" -int "2"
write_default eu.exelban.Stats "CPU_oneView" -bool false
write_default eu.exelban.Stats "CPU_pieChart_position" -int "4"
write_default eu.exelban.Stats "CPU_tachometer_position" -int "5"
write_default eu.exelban.Stats "CPU_widget" -string "line_chart"

# Configure GPU stats
write_default eu.exelban.Stats "GPU_barChart_position" -int "0"
write_default eu.exelban.Stats "GPU_bar_chart_box" -bool false
write_default eu.exelban.Stats "GPU_bar_chart_frame" -bool false
write_default eu.exelban.Stats "GPU_bar_chart_label" -bool true
write_default eu.exelban.Stats "GPU_label_position" -int "1"
write_default eu.exelban.Stats "GPU_lineChart_position" -int "3"
write_default eu.exelban.Stats "GPU_mini_position" -int "2"
write_default eu.exelban.Stats "GPU_tachometer_position" -int "4"
write_default eu.exelban.Stats "GPU_widget" -string "bar_chart"

# Configure RAM stats
write_default eu.exelban.Stats "RAM_barChart_position" -int "3"
write_default eu.exelban.Stats "RAM_label_position" -int "1"
write_default eu.exelban.Stats "RAM_lineChart_position" -int "0"
write_default eu.exelban.Stats "RAM_line_chart_box" -bool false
write_default eu.exelban.Stats "RAM_line_chart_frame" -bool true
write_default eu.exelban.Stats "RAM_line_chart_label" -bool true
write_default eu.exelban.Stats "RAM_line_chart_valueColor" -bool false
write_default eu.exelban.Stats "RAM_memory_position" -int "5"
write_default eu.exelban.Stats "RAM_mini_position" -int "2"
write_default eu.exelban.Stats "RAM_pieChart_position" -int "4"
write_default eu.exelban.Stats "RAM_tachometer_position" -int "6"
write_default eu.exelban.Stats "RAM_widget" -string "line_chart"

# Configure Network stats
write_default eu.exelban.Stats "Network_label_position" -int "1"
write_default eu.exelban.Stats "Network_networkChart_position" -int "0"
write_default eu.exelban.Stats "Network_network_chart_frame" -bool true
write_default eu.exelban.Stats "Network_network_chart_label" -bool true
write_default eu.exelban.Stats "Network_speed_position" -int "2"
write_default eu.exelban.Stats "Network_state_position" -int "3"
write_default eu.exelban.Stats "Network_widget" -string "network_chart"

# Rectangle

# Ensure onboarding has been completed before writing defaults
ensure_onboarding_completed com.knollsoft.Rectangle Rectangle /Applications/Rectangle.app
if [ $? == 1 ]
then
    exit 1
fi

# Prevent the rectangle settings from messing this up
kill_process "Rectangle"

# Launch at startup
write_default com.knollsoft.Rectangle launchOnLogin -bool true

# Hide menu bar icon
write_default com.knollsoft.Rectangle hideMenubarIcon -bool true

# Automatic updates
write_default com.knollsoft.Rectangle SUEnableAutomaticChecks -bool true

# Kill affected applications
for app in "Activity Monitor" \
	"Disk Utility" \
	"SystemUIServer" \
	"WindowServer"; do
	killall "${app}" &> /dev/null
done
