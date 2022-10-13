#!/usr/bin/env bash

# Open stats so that it populates the defaults
open /Applications/Stats.app

# Run on login
defaults write eu.exelban.Stats runAtLoginInitialized -bool true

# Don't show in the dock
defaults write eu.exelban.Stats dockIcon -bool false

# Only show relevant stats
defaults write eu.exelban.Stats CPU_state -bool true
defaults write eu.exelban.Stats GPU_state -bool true
defaults write eu.exelban.Stats RAM_state -bool true
defaults write eu.exelban.Stats Network_state -bool true
defaults write eu.exelban.Stats Sensors_state -bool false
defaults write eu.exelban.Stats Disk_state -bool false
defaults write eu.exelban.Stats Battery_state -bool false

# Configure CPU stats
defaults write eu.exelban.Stats "CPU_barChart_position" -int "3"
defaults write eu.exelban.Stats "CPU_label_position" -int "1"
defaults write eu.exelban.Stats "CPU_lineChart_position" -int "0"
defaults write eu.exelban.Stats "CPU_line_chart_box" -bool false
defaults write eu.exelban.Stats "CPU_line_chart_frame" -bool true
defaults write eu.exelban.Stats "CPU_line_chart_label" -bool true
defaults write eu.exelban.Stats "CPU_line_chart_value" -bool false
defaults write eu.exelban.Stats "CPU_line_chart_valueColor" -bool false
defaults write eu.exelban.Stats "CPU_mini_position" -int "2"
defaults write eu.exelban.Stats "CPU_oneView" -bool false
defaults write eu.exelban.Stats "CPU_pieChart_position" -int "4"
defaults write eu.exelban.Stats "CPU_tachometer_position" -int "5"
defaults write eu.exelban.Stats "CPU_widget" -string "line_chart"

# Configure GPU stats
defaults write eu.exelban.Stats "GPU_barChart_position" -int "0"
defaults write eu.exelban.Stats "GPU_bar_chart_box" -bool false
defaults write eu.exelban.Stats "GPU_bar_chart_frame" -bool false
defaults write eu.exelban.Stats "GPU_bar_chart_label" -bool true
defaults write eu.exelban.Stats "GPU_label_position" -int "1"
defaults write eu.exelban.Stats "GPU_lineChart_position" -int "3"
defaults write eu.exelban.Stats "GPU_mini_position" -int "2"
defaults write eu.exelban.Stats "GPU_tachometer_position" -int "4"
defaults write eu.exelban.Stats "GPU_widget" -string "bar_chart"

# Configure RAM stats
defaults write eu.exelban.Stats "RAM_barChart_position" -int "3"
defaults write eu.exelban.Stats "RAM_label_position" -int "1"
defaults write eu.exelban.Stats "RAM_lineChart_position" -int "0"
defaults write eu.exelban.Stats "RAM_line_chart_box" -bool false
defaults write eu.exelban.Stats "RAM_line_chart_frame" -bool true
defaults write eu.exelban.Stats "RAM_line_chart_label" -bool true
defaults write eu.exelban.Stats "RAM_line_chart_valueColor" -bool false
defaults write eu.exelban.Stats "RAM_memory_position" -int "5"
defaults write eu.exelban.Stats "RAM_mini_position" -int "2"
defaults write eu.exelban.Stats "RAM_pieChart_position" -int "4"
defaults write eu.exelban.Stats "RAM_tachometer_position" -int "6"
defaults write eu.exelban.Stats "RAM_widget" -string "line_chart"

# Configure Network stats
defaults write eu.exelban.Stats "Network_label_position" -int "1"
defaults write eu.exelban.Stats "Network_networkChart_position" -int "0"
defaults write eu.exelban.Stats "Network_network_chart_frame" -bool true
defaults write eu.exelban.Stats "Network_network_chart_label" -bool true
defaults write eu.exelban.Stats "Network_speed_position" -int "2"
defaults write eu.exelban.Stats "Network_state_position" -int "3"
defaults write eu.exelban.Stats "Network_widget" -string "network_chart"

# Restart stats
killall "Stats"
open /Applications/Stats.app
