local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Apple System Colors'
config.font = wezterm.font 'SFMono Nerd Font'

config.enable_tab_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
