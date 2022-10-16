#!/usr/bin/env bash

source $PWD/utils.sh
source $PWD/macos/defaults.sh

echo "📈 Configuring Stats"
default_command_prefix="📈"

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
