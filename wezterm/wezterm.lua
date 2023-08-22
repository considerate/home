local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end

config.window_padding = {left = 0, right = 0, top = 0, bottom = 0}
config.use_fancy_tab_bar = false
config.dpi = 192.0

local ocean = wezterm.color.get_builtin_schemes()['Ocean (base16)']

config.color_scheme = 'Ocean (base16)'
config.font = wezterm.font_with_fallback {
    "Fira Code", {family = "DejaVu Sans Mono", scale = 1.5}
}

config.adjust_window_size_when_changing_font_size = false

config.colors = {
    tab_bar = {
        background = ocean.background,
        active_tab = {bg_color = ocean.indexed[18], fg_color = ocean.foreground},
        inactive_tab = {
            bg_color = ocean.background,
            fg_color = ocean.foreground
        },
        inactive_tab_hover = {
            fg_color = ocean.selection_fg,
            bg_color = ocean.selection_bg
        },
        new_tab = {bg_color = ocean.indexed[18], fg_color = ocean.foreground},
        new_tab_hover = {
            fg_color = ocean.selection_fg,
            bg_color = ocean.selection_bg
        }
    }
}
config.hide_tab_bar_if_only_one_tab = true

return config
