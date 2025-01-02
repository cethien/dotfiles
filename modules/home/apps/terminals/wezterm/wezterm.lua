local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- issue with nix package, text is rendered as a box
config.front_end = "WebGpu"

config.check_for_updates = false

config.font = wezterm.font 'MesloLGM Nerd Font Mono'
config.font_size = 14
config.color_scheme = 'Catppuccin Mocha'

config.animation_fps = 200

config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

config.hide_tab_bar_if_only_one_tab = true

config.command_palette_rows = 12
config.command_palette_font_size = 14
config.command_palette_bg_color = "#181825"
config.command_palette_fg_color = "#cdd6f4"

return config