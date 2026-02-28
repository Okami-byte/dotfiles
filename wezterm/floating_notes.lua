local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local mux = wezterm.mux
local act = wezterm.action

local config_file = io.open(wezterm.config_dir .. "/floating_notes_config.json")
local notes_config = wezterm.json_parse(config_file:read("*a"))
config_file:close()

config = {

	-- Always return the configured window title
	wezterm.on("format-window-title", function()
		return notes_config.window_title
	end),

	-- Force "Always On Top" and position on right side of screen on startup
	wezterm.on("gui-startup", function(cmd)
		local tab, pane, window = mux.spawn_window(cmd or {})
		local gui = window:gui_window()
		gui:perform_action(act.ToggleAlwaysOnTop, pane)

		-- Position on the right side of the active screen
		local screen = wezterm.gui.screens().active
		local dims = gui:get_dimensions()
		local x = screen.x + screen.width - dims.pixel_width - 50
		local y = screen.y + 120
		gui:set_position(x, y)
	end),

	default_cwd = "/Users/fox/Notes/06 - Daily",

	default_prog = {
		"/opt/homebrew/bin/nvim",
		"-c",
		":Obsidian today",
	},

	window_decorations = "RESIZE",
	macos_window_background_blur = 90,
	window_background_opacity = 0.70,
	initial_cols = 50,
	initial_rows = 40,
	window_padding = {
		left = 0,
		right = 0,
		top = 10,
		bottom = 0,
	},
	exit_behavior = "Close",
	enable_tab_bar = false,
	font_size = 13,
}

return config
