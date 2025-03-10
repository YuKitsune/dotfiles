#!/usr/bin/env bash

source $PWD/scripts/utils.sh

# Set up a trap to catch the interrupt signal and exit the script
trap 'echo "SIGINT detected. Exiting..."; exit 1' SIGINT

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
    defaults write NSGlobalDomain AppleInterfaceStyle -string Dark
    defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool false

    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Keyboard and Trackpad

    # Keyboard: Use F-keys as normal function keys
    defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

    # Keyboard: Set a blazingly fast keyboard repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 10

    # Trackpad: Enable tap to click for this user and for the login screen
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Trackpad: Tracking speed
    defaults write .GlobalPreferences com.apple.trackpad.scaling -int 1

    # Siri
    defaults write com.apple.assistant.support "Assistant Enabled" -bool false

    # Audio

    # Increase sound quality for Bluetooth headphones/headsets
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

    # Screen

    # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0

    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable Live-Text
    defaults write NSGlobalDomain AppleLiveTextEnabled -bool false
}

function configure_finder() {

    # Finder: Allow quitting via ⌘ + Q; doing so will also hide desktop icons
    defaults write com.apple.finder QuitMenuItem -bool true

    # Sync Desktop and Documents
    defaults write com.apple.finder FXICloudDriveDesktop -bool true
    defaults write com.apple.finder FXICloudDriveDocuments -bool true

    # Set $HOME as the default location for new Finder windows
    # Computer     : `PfCm`
    # Volume       : `PfVo`
    # $HOME        : `PfHm`
    # Desktop      : `PfDe`
    # Documents    : `PfDo`
    # All My Files : `PfAF`
    # Other…       : `PfLo`
    defaults write com.apple.finder NewWindowTarget -string 'PfHm'
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

    # Show icons for hard drives, servers, and removable media on the desktop
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

    # Sidebar sections
    defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true
    defaults write com.apple.finder SidebarPlacesSectionDisclosedState -bool true
    defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool true
    defaults write com.apple.finder SidebarShowingiCloudDesktop -bool true
    defaults write com.apple.finder SidebarTagsSctionDisclosedState -bool false

    # Search the current folder when searching
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Show hidden files by default
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Remove trash items after 30 days
    defaults write com.apple.finder FXRemoveOldTrashItems -bool true

    # View Options

    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Tab Bar
    # Show icon and text in the tab bar
    /usr/libexec/PlistBuddy -c "Set :\"NSToolbar Configuration Browser\":\"TB Display Mode\" 1" $HOME/Library/Preferences/com.apple.finder.plist

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Use column view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
    defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

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

    # Configure sidebar favourites
    mysides add Recent file:///System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch/
    mysides add Home file://$HOME/
    mysides add Desktop file://$HOME/Desktop/
    mysides add Documents "file://$HOME/Documents/"
    mysides add Code file://$HOME/Code/
    mysides add Applications file:///Applications/
    mysides add Downloads file://$HOME/Downloads/

    kill_process "Finder"
}

function add_dock_item() {
    path=$1
    echo "📝 Adding $path to dock" > /dev/tty

    dockutil --add $path --no-restart > /dev/null
    print_result_if_failed $? "Failed to set dock item"
}

function configure_dock() {
    # Set the size of the dock
    defaults write com.apple.dock "tilesize" -int "40"

    # Automatically hide the dock
    defaults write com.apple.dock "autohide" -bool "true"

    # Remove the animation delay
    defaults write com.apple.dock "autohide-delay" -float 0

    # Instantly reveal the dock
    defaults write com.apple.dock "autohide-time-modifier" -float 0.5

    # Enable magnification
    defaults write com.apple.dock "magnification" -bool true

    # Set the magnification size
    defaults write com.apple.dock "largesize" -int "80"

    # Show indicator lights for open applications in the Dock
    defaults write com.apple.dock show-process-indicators -bool true

    # Make Dock icons of hidden applications translucent
    defaults write com.apple.dock showhidden -bool true

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

    add_dock_item /System/Cryptexes/App/System/Applications/Safari.app

    add_dock_item /System/Applications/Mail.app
    add_dock_item /System/Applications/Calendar.app
    add_dock_item /System/Applications/Notes.app
    if [[ $PROFILE = 'work' ]]; then
        add_dock_item /Applications/Obsidian.app
    fi

    add_dock_item /System/Applications/Reminders.app
    add_dock_item /System/Applications/Messages.app
    add_dock_item /Applications/Discord.app

    if [[ $PROFILE = 'work' ]]; then
        add_dock_item /Applications/Slack.app
    fi

    add_dock_item /Applications/Spotify.app
    add_dock_item /Applications/Ghostty.app
    add_dock_item ~/Downloads

    kill_process "Dock"
}

function configure_safari() {

    # Use the compact tab bar
    defaults write com.apple.Safari ShowStandaloneTabBar -bool false

    # Privacy: Don’t send search queries to Apple
    defaults write com.apple.Safari UniversalSearchEnabled -bool false
    defaults write com.apple.Safari SuppressSearchSuggestions -bool true

    # Disable auto-correct
    defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
    defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

    # Show the full URL in the address bar (note: this still hides the scheme)
    defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

    # Prevent Safari from opening ‘safe’ files automatically after downloading
    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

    # Hide Safari’s bookmarks bar by default
    defaults write com.apple.Safari ShowFavoritesBar -bool false

    # Hide Safari’s sidebar in Top Sites
    defaults write com.apple.Safari ShowSidebarInTopSites -bool false

    # Disable Safari’s thumbnail cache for History and Top Sites
    defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

    # Enable Safari’s debug menu
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

    # Make Safari’s search banners default to Contains instead of Starts With
    defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

    # Remove useless icons from Safari’s bookmarks bar
    defaults write com.apple.Safari ProxiesInBookmarksBar -string "()"

    # Enable the Develop menu and the Web Inspector in Safari
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

    # Add a context menu item for showing the Web Inspector in web views
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

    # Disable AutoFill
    defaults write com.apple.Safari AutoFillFromAddressBook -bool false
    defaults write com.apple.Safari AutoFillPasswords -bool false
    defaults write com.apple.Safari AutoFillCreditCardData -bool false
    defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

    # Warn about fraudulent websites
    defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

    # Disable plug-ins
    defaults write com.apple.Safari WebKitPluginsEnabled -bool false
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

    # Disable Java
    defaults write com.apple.Safari WebKitJavaEnabled -bool false
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

    # Block pop-up windows
    defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

    # Enable “Do Not Track”
    defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

    # Update extensions automatically
    defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

    # Enable privacy protection for both normal and private browsing
    defaults write com.apple.Safari EnableEnhancedPrivacyInRegularBrowsing -bool true

    # Enable developer tools
    defaults write com.apple.Safari IncludeDevelopMenu -bool true

    # Warn before connecting to HTTP websites
    defaults write com.apple.Safari UseHTTPSOnly -bool true

    # Prevent cross-site tracking
    defaults write com.apple.Safari BlockStoragePolicy -int 2
    defaults write com.apple.Safari WebKitPreferences.storageBlockingPolicy -int 1
    defaults write com.apple.Safari WebKitStorageBlockingPolicy -int 1

    # Hide IP address
    # - From trackers and websites: 66976960
    # - From trackers only: 66976972
    defaults write com.apple.Safari WBSPrivacyProxyAvailabilityTraffic -int 66976960

    # Disable privacy preserving ads
    defaults write com.apple.Safari WebKitPreferences.privateClickMeasurementEnabled -bool false

    # Configure toolbar
    defaults write com.apple.Safari "NSToolbar Configuration BrowserToolbarIdentifier-v4.6" \
    '{
        "TB Display Mode" = 2;
        "TB Item Identifiers" = (
            CombinedSidebarTabGroupToolbarIdentifier,
            SidebarSeparatorToolbarItemIdentifier,
            BackForwardToolbarIdentifier,
            UnifiedTabBarToolbarIdentifier,
            ShowWebInspectorToolbarIdentifier,
            ShowDownloadsToolbarIdentifier,
            "WebExtension-com.bitwarden.desktop.safari (LTZ2PFU5D6)",
            NewTabToolbarIdentifier
        );
    }'

    defaults write com.apple.Safari "ExtensionsToolbarConfiguration BrowserToolbarIdentifier-v4.6" \
    '{
        "OrderedToolbarItemIdentifiers" = (
            SidebarSeparatorToolbarItemIdentifier,
            BackForwardToolbarIdentifier,
            UnifiedTabBarToolbarIdentifier,
            "com.adguard.safari.AdGuard.Extension (TC3Q7MAJXF) Button",
            ShowWebInspectorToolbarIdentifier,
            ShowDownloadsToolbarIdentifier,
            "WebExtension-com.bitwarden.desktop.safari (LTZ2PFU5D6)",
            NewTabToolbarIdentifier
        );
        UserRemovedToolbarItemIdentifiers =(
            "com.adguard.safari.AdGuard.Extension (TC3Q7MAJXF) Button"
        );
    }'

    kill_process "Safari"
}

function configure_mail() {

    # Tool Bar
    # Show icon and text in the tab bar
    defaults write com.apple.mail "NSToolbar Configuration MainWindow" \
        '{
            "TB Display Mode" = 1;
            "TB Icon Size Mode" = 1;
            "TB Is Shown" = 1;
            "TB Size Mode" = 1;
        }'

    kill_process "Mail"
}

function configure_calendar() {
    defaults write com.apple.iCal "TimeZone support enabled" -bool true
    defaults write com.apple.iCal "last calendar view description" -string "Daily"
}

function configure_app_store() {
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
}

# 3rd Party Applications

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
    defaults write com.knollsoft.Rectangle launchOnLogin -bool true

    # Hide menu bar icon
    defaults write com.knollsoft.Rectangle hideMenubarIcon -bool true

    # Automatic updates
    defaults write com.knollsoft.Rectangle SUEnableAutomaticChecks -bool true

    # Gap size
    defaults write com.knollsoft.Rectangle gapSize -int 20

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
    # Ensure onboarding has been completed before writing defaults
    ensure_onboarding_completed com.DanPristupov.Fork Fork /Applications/Fork.app
    defaults write com.DanPristupov.Fork defaultSourceFolder -string "$HOME/Code"
}

echo "🤔 Which of these apps do you want to configure?"
apps=$(gum choose --no-limit "macos" "finder" "dock" "mail" "calendar" "safari" "app store" "mos" "rectangle" "fork")

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

element_exists_in_array "calendar" ${apps[*]}
if [ $? -eq 0 ]
then
    configure_calendar
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
