#!/usr/bin/env bash

source $PWD/scripts/utils.sh

# Set up a trap to catch the interrupt signal and exit the script
trap 'echo "SIGINT detected. Exiting..."; exit 1' SIGINT

function write_default() {
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

function ensure_onboarding_completed() {
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

function kill_process() {
    name=$1
    pgrep $name > /dev/null
    if [ $? -eq 0 ]
    then
        gum confirm "🫣 Kill $name?"
        if [ $? -eq 0 ]
        then
            echo "🔫 Killing $name" > /dev/tty
            killall "$name"
        else
            echo "😮‍💨 $name spared. It may require a restart." > /dev/tty
            return 1
        fi
    fi

    return 0
}

dir=$(dirname "$0")

# Todo: Configure menu bar

function configure_macos() {

    echo "To prevent the System Settings app from overriding any of the settings we're about to change, we need to kill it."
    kill_process "System Settings"
    if [ $? -ne 0 ]
    then
        echo "Skipping System Settings..."
        return 1
    fi

    # General UI/UX

    # Dark mode
    write_default NSGlobalDomain AppleInterfaceStyle -string Dark
    write_default NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool false

    # Expand save panel by default
    write_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    write_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Keyboard and Trackpad

    # Keyboard: Use F-keys as normal function keys
    write_default NSGlobalDomain com.apple.keyboard.fnState -bool true

    # Keyboard: Set a blazingly fast keyboard repeat rate
    write_default NSGlobalDomain KeyRepeat -int 1
    write_default NSGlobalDomain InitialKeyRepeat -int 10

    # Trackpad: Enable tap to click for this user and for the login screen
    write_default com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    write_default NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Trackpad: Tracking speed
    write_default .GlobalPreferences com.apple.trackpad.scaling -int 1

    # Siri
    write_default com.apple.assistant.support "Assistant Enabled" -bool false

    # Audio

    # Increase sound quality for Bluetooth headphones/headsets
    write_default com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

    # Screen

    # Require password immediately after sleep or screen saver begins
    write_default com.apple.screensaver askForPassword -int 1
    write_default com.apple.screensaver askForPasswordDelay -int 0

    # Disable auto-correct
    write_default NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable Live-Text
    write_default NSGlobalDomain AppleLiveTextEnabled -bool false
}

function configure_finder() {

    # Finder: Allow quitting via ⌘ + Q; doing so will also hide desktop icons
    write_default com.apple.finder QuitMenuItem -bool true

    # Set $HOME as the default location for new Finder windows
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

    # Search the current folder when searching
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

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
    sudo chflags nohidden /Volumes

    # Expand the following File Info panes:
    # “General”, “Open with”, and “Sharing & Permissions”
    defaults write com.apple.finder FXInfoPanesExpanded -dict \
        General -bool true \
        OpenWith -bool true \
        Privileges -bool true

    # Todo: Configure sidebar favourites

    kill_process "Finder"
}

function configure_activitymonitor() {

    # Show all processes in Activity Monitor
    write_default com.apple.ActivityMonitor ShowCategory -int 0

    # Sort Activity Monitor results by CPU usage
    write_default com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    write_default com.apple.ActivityMonitor SortDirection -int 0

    kill_process "Activity Monitor"
}

function configure_diskutility() {
    # Enable the debug menu in Disk Utility
    write_default com.apple.DiskUtility DUDebugMenuEnabled -bool true
    write_default com.apple.DiskUtility advanced-image-options -bool true

    kill_process "Disk Utility"
}

function add_dock_item() {
    path=$1
    echo "📝 Adding $path to dock" > /dev/tty

    dockutil --add $path --no-restart > /dev/null
    print_result_if_failed $? "Failed to set dock item"
}

function configure_dock() {
    # Set the size of the dock
    write_default com.apple.dock "tilesize" -int "40"

    # Automatically hide the dock
    defaults write com.apple.dock "autohide" -bool "true"

    # Remove the animation delay
    defaults write com.apple.dock "autohide-delay" -float 0

    # Instantly reveal the dock
    defaults write com.apple.dock "autohide-time-modifier" -float 0.5

    # Enable magnification
    write_default com.apple.dock "magnification" -bool true

    # Set the magnification size
    write_default com.apple.dock "largesize" -int "80"

    # Show indicator lights for open applications in the Dock
    write_default com.apple.dock show-process-indicators -bool true

    # Make Dock icons of hidden applications translucent
    write_default com.apple.dock showhidden -bool true

    # Prevent spaces from rearranging based on activity 
    defaults write com.apple.dock "mru-spaces" -bool "false"

    # Group windows by application in mission control
    defaults write com.apple.dock "expose-group-apps" -bool "true"

    # Don't show recents
    defaults write com.apple.dock "show-recents" -bool "false"

    # Minimise applications into their dock icon
    defaults write com.apple.dock "minimize-to-application" -bool "true"

    # Setup the dock icons
    echo "📝 Clearing dock" > /dev/tty
    dockutil --remove all --no-restart

    if [[ $PROFILE = 'work' ]]; then
        add_dock_item /Applications/Arc.app
    else
        add_dock_item /System/Cryptexes/App/System/Applications/Safari.app
    fi

    add_dock_item /System/Applications/Mail.app
    add_dock_item /System/Applications/Calendar.app
    add_dock_item /Applications/Obsidian.app
    add_dock_item /System/Applications/Reminders.app
    add_dock_item /System/Applications/Messages.app
    add_dock_item /Applications/Discord.app

    if [[ $PROFILE = 'work' ]]; then
        add_dock_item /Applications/Slack.app
    fi

    add_dock_item /Applications/Spotify.app
    add_dock_item /Applications/WezTerm.app
    add_dock_item ~/Downloads

    kill_process "Dock"
}

function configure_safari() {

    # Use the compact tab bar
    write_default com.apple.Safari ShowStandaloneTabBar -bool false

    # Privacy: Don’t send search queries to Apple
    write_default com.apple.Safari UniversalSearchEnabled -bool false
    write_default com.apple.Safari SuppressSearchSuggestions -bool true

    # Disable auto-correct
    write_default com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
    write_default NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

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

    # Enable privacy protection for both normal and private browsing
    write_default com.apple.Safari EnableEnhancedPrivacyInRegularBrowsing -bool true

    # Todo: Toolbar layout

    kill_process "Safari"
}

function configure_mail() {

    # Tool Bar
    # Show icon and text in the tab bar
    /usr/libexec/PlistBuddy -c "Set :\"NSToolbar Configuration MainWindow\":\"TB Display Mode\" 1" /Users/eoinmotherway/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist

    kill_process "Mail"
}

function configure_app_store() {
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
}

# 3rd Party Applications

function configure_mos() {
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
}

function configure_rectangle() {
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

    # Gap size
    write_default com.knollsoft.Rectangle gapSize -int 20

    # Todo: Key bindings for 6ths
    # bottomCenterSixth =     {
    #     keyCode = 23;
    #     modifierFlags = 786432;
    # };
    # bottomLeftSixth =     {
    #     keyCode = 21;
    #     modifierFlags = 786432;
    # };
    # bottomRightSixth =     {
    #     keyCode = 22;
    #     modifierFlags = 786432;
    # };
    # topCenterSixth =     {
    #     keyCode = 19;
    #     modifierFlags = 786432;
    # };
    # topLeftSixth =     {
    #     keyCode = 18;
    #     modifierFlags = 786432;
    # };
    # topRightSixth =     {
    #     keyCode = 20;
    #     modifierFlags = 786432;
    # };
}

function configure_fork() {
    write_default com.DanPristupov.Fork defaultSourceFolder -string "$HOME/Developer"
}

function configure_finder_sidebar() {
    mysides add Recent file:///System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch/
    mysides add Home file://$HOME/
    mysides add Desktop file://$HOME/Desktop/
    mysides add Documents file://$HOME/Documents/
    mysides add Developer file://$HOME/Developer/
    mysides add Applications file:///Applications/
    mysides add Downloads file://$HOME/Downloads/
}

echo "🤔 Which of these apps do you want to configure?"
apps=$(gum choose --no-limit "macos" "finder" "dock" "mail" "activity_monitor" "disk_utility" "safari" "app store" "mos" "rectangle" "fork")

# First-party

element_exists_in_array "macos" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_macos
fi

element_exists_in_array "finder" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_finder
    configure_finder_sidebar
fi

element_exists_in_array "activity_monitor" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_activitymonitor
fi

element_exists_in_array "disk_utility" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_diskutility
fi

element_exists_in_array "dock" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_dock
fi

element_exists_in_array "mail" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_mail
fi

element_exists_in_array "safari" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_safari
fi

element_exists_in_array "app store" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_app_store
fi

# Third-party

# TODO: Configure startup applications

element_exists_in_array "rectangle" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_rectangle
fi

element_exists_in_array "fork" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_fork
fi
