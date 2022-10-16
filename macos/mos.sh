#!/usr/bin/env bash

source $PWD/utils.sh
source $PWD/macos/defaults.sh

echo "🖱 Configuring Mos"
default_command_prefix="🖱"

ensure_onboarding_completed com.caldis.Mos Mos /Applications/Mos.app
if [ $? == 1 ]
then
    exit 1
fi

# Prevent the mos settings from messing this up
kill_process "Mos"

# Hide menu bar icon
write_default com.caldis.Mos hideStatusItem -bool true
