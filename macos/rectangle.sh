#!/usr/bin/env bash

source $PWD/utils.sh
source $PWD/macos/defaults.sh

echo "🖥 Configuring Rectangle"
default_command_prefix="🖥"

# Prevent the rectangle settings from messing this up
kill_process "Rectangle"

# Launch at startup
write_default com.knollsoft.Rectangle launchOnLogin -bool true

# Hide menu bar icon
write_default com.knollsoft.Rectangle hideMenubarIcon -bool true

# Automatic updates
write_default com.knollsoft.Rectangle SUEnableAutomaticChecks -bool true

# Reopen Rectangle
open /Applications/Stats.app
