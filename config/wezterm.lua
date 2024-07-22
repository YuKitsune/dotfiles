local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Theme and font
config.font = wezterm.font 'SFMono Nerd Font'
config.color_scheme = 'Apple System Colors'

-- Hide the tab bar
config.enable_tab_bar = false

return config
