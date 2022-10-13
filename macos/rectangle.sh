#!/usr/bin/env bash

# Prevent the rectangle settings from messing this up
killall "Rectangle"

# Launch at startup
defaults write com.knollsoft.Rectangle launchOnLogin -bool true

# Hide menu bar icon
defaults write com.knollsoft.Rectangle hideMenubarIcon -bool true

# Automatic updates
defaults write com.knollsoft.Rectangle SUEnableAutomaticChecks -bool true

# Reopen Rectangle
open /Applications/Stats.app
