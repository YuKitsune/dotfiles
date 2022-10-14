#!/usr/bin/env bash

source $PWD/utils.sh
source $PWD/macos/defaults.sh

echo "🖱 Configuring Mos"
default_command_prefix="🖱"

# Open Mos so that it populates the defaults
open /Applications/Mos.app

# Hide menu bar icon
write_default com.caldis.Mos hideStatusItem -bool true

# Restart Mos
kill_process "Mos"
open /Applications/Mos.app
