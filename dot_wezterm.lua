local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.color_scheme = "Numix Darkest (terminal.sexy)"
config.font = wezterm.font("Spleen 16x32")
config.font_size = 16
config.colors = {
	visual_bell = "#202020",
}
-- config.visual_bell = {
-- 	fade_in_duration_ms = 75,
-- 	fade_out_duration_ms = 75,
-- 	target = "CursorColor",
-- }
config.visual_bell = {
	fade_in_function = "EaseIn",
	fade_in_duration_ms = 150,
	fade_out_function = "EaseOut",
	fade_out_duration_ms = 150,
}
config.audible_bell = "Disabled"
return config
