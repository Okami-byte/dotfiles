local wezterm = require("wezterm")

local config = wezterm.config_builder()

local mux = wezterm.mux
local act = wezterm.action

config = {

	wezterm.on("format-window-title", function()
		return "SCRATCHPAD"
	end),

	wezterm.on("gui-startup", function(cmd)
		local tab, pane, window = mux.spawn_window(cmd or {})
		local gui = window:gui_window()
		gui:perform_action(act.ToggleAlwaysOnTop, pane)

		local screen = wezterm.gui.screens().active
		local dims = gui:get_dimensions()
		local x = screen.x + math.floor((screen.width - dims.pixel_width) / 2)
		local y = screen.y + 60
		gui:set_position(x, y)
	end),

	window_decorations = "RESIZE",
	macos_window_background_blur = 90,
	window_background_opacity = 0.70,
	initial_cols = 70,
	initial_rows = 18,
	window_padding = {
		left = 8,
		right = 8,
		top = 10,
		bottom = 8,
	},
	exit_behavior = "Close",
	enable_tab_bar = false,
	font_size = 13,
	enable_kitty_graphics = true,

	color_scheme = "Catppuccin Mocha (Gogh)",
	colors = {
		background = "#111419",
	},
}

return config
