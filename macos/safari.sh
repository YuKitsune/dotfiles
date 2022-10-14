#!/usr/bin/env bash

source $PWD/utils.sh
source $PWD/macos/defaults.sh

echo "🌏 Configuring Safari"
default_command_prefix="🌏"

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
write_default com.apple.Safari ProxiesInBookmarksBar "()"

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
