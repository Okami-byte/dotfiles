-- Filename: ~/.dotfiles/wezterm/wezterm.lua
--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

-- Pull in the wezterm API

local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Light / Dark mode aware appearance (scheme, background, blur, opacity)
-- https://wezterm.org/config/lua/window/get_appearance.html
--
-- Single source of truth: tweak the numbers/colors below and save -- this
-- also keeps already-open windows in sync, not just newly created ones,
-- because window-config-reloaded fires on plain file edits too.
local appearance_settings = {
	light = {
		color_scheme = "Rosé Pine Dawn (Gogh)",
		colors = {},
		macos_window_background_blur = 99,
		window_background_opacity = 0.30,
	},
	dark = {
		color_scheme = "Rosé Pine (Gogh)",
		colors = { background = "#1f2227" },
		macos_window_background_blur = 95,
		window_background_opacity = 0.60,
	},
}

local function settings_for_appearance(appearance)
	if appearance:find("Dark") then
		return appearance_settings.dark
	else
		return appearance_settings.light
	end
end

-- Used for the config's initial load, before any window exists
local initial_settings = settings_for_appearance(wezterm.gui.get_appearance())

-- Re-sync every open window's overrides whenever the config reloads, whether
-- that's triggered by a system appearance change or by hand-editing the
-- settings above (automatically_reload_config fires this event either way)
wezterm.on("window-config-reloaded", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local settings = settings_for_appearance(window:get_appearance())
	local changed = overrides.color_scheme ~= settings.color_scheme
		or overrides.macos_window_background_blur ~= settings.macos_window_background_blur
		or overrides.window_background_opacity ~= settings.window_background_opacity
		or (overrides.colors and overrides.colors.background) ~= settings.colors.background
	if changed then
		overrides.color_scheme = settings.color_scheme
		overrides.colors = settings.colors
		overrides.macos_window_background_blur = settings.macos_window_background_blur
		overrides.window_background_opacity = settings.window_background_opacity
		window:set_config_overrides(overrides)
	end
end)

-- This is where you actually apply your config choices
config = {

	-- -- Setting the term to wezterm is what allows support for undercurl
	-- --
	-- -- BEFORE you can set the term to wezterm, you need to install a copy of the
	-- -- wezterm TERM definition
	-- -- https://wezfurlong.org/wezterm/config/lua/config/term.html?h=term
	-- -- https://github.com/wez/wezterm/blob/main/termwiz/data/wezterm.terminfo
	-- --
	-- -- If you're using tmux, set your tmux.conf file to:
	-- -- set -g default-terminal "${TERM}"
	-- -- So that it picks up the wezterm TERM we're defining here
	-- --
	-- -- NOTE: When inside neovim, run a `checkhealth` and under `tmux` you will see that
	-- -- the term is set to `wezterm`. If the term is set to something else:
	-- -- - Reload your tmux configuration,
	-- -- - Then close all your tmux sessions, one at a time and quit wezterm
	-- -- - re-open wezterm
	-- term = "wezterm",
	-- term = "xterm-256color",

	-- When using the wezterm terminfo file, I had issues with images in neovim, images
	-- were shown like split in half, and some part of the image always stayed on the
	-- screen until I quit neovim
	--
	-- Images are working wonderfully in kitty, so decided to try the kitty.terminfo file
	-- https://github.com/kovidgoyal/kitty/blob/master/terminfo/kitty.terminfo
	--
	-- NOTE: I added a modified version of this in my zshrc file, so if the kitty terminfo
	-- file is not present it will be downloaded and installed automatically
	--
	-- But if you want to manually download and install the kitty terminfo file
	-- run the command below on your terminal:
	-- tempfile=$(mktemp) && curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo && tic -x -o ~/.terminfo "$tempfile" && rm "$tempfile"
	--
	-- NOTE: When inside neovim, run a `checkhealth` and under `tmux` you will see that
	-- the term is set to `xterm-kitty`. If the term is set to something else:
	-- - Reload your tmux configuration,
	-- - Then close all your tmux sessions, one at a time and quit wezterm
	-- - re-open wezterm
	--
	-- Then you'll be able to set your terminal to `xterm-kitty` as seen below
	-- term = "xterm-kitty",

	-- To enable kitty graphics
	-- https://github.com/wez/wezterm/issues/986
	-- It seems that kitty graphics is not enabled by default according to this
	-- Not sure, so I'm enabling it just in case
	-- https://github.com/wez/wezterm/issues/1406#issuecomment-996253377
	enable_kitty_graphics = true,

	-- I got the GPU settings below from a comment by user @anthonyknowles
	-- In my wezterm video and will test them out
	-- https://youtu.be/ibCPb4tSRXM
	-- https://wezfurlong.org/wezterm/config/lua/config/animation_fps.html?h=animation
	animation_fps = 120,

	-- Limits the maximum number of frames per second that wezterm will attempt to draw
	-- I tried settings this value to 5, 15, 30, 60 and you do feel a difference
	-- It feels WAY SMOOTHER at 120
	-- In my humble opiniont, 120 should be the default as I'm not the only one
	-- experiencing this "performance" issue in wezterm
	-- https://wezfurlong.org/wezterm/config/lua/config/max_fps.html
	max_fps = 120,

	-- front_end = "WebGpu" - will more directly use Metal than the OpenGL
	-- The default is "WebGpu". In earlier versions it was "OpenGL"
	-- Metal translation used on M1 machines, may yield some more fps.
	-- https://github.com/wez/wezterm/discussions/3664
	-- https://wezfurlong.org/wezterm/config/lua/config/front_end.html?h=front_
	-- front_end = "WebGpu",

	-- https://wezfurlong.org/wezterm/config/lua/config/webgpu_preferred_adapter.html?h=webgpu_preferred_adapter
	-- webgpu_preferred_adapter

	-- webgpu_power_preference = "LowPower"
	-- https://wezfurlong.org/wezterm/config/lua/config/webgpu_power_preference.html

	-- I use this for ñ and tildes in spanish á é í ó ú
	-- If you're a gringo, you wouldn't understand :wink:
	-- https://github.com/wez/wezterm/discussions/4650
	-- send_composed_key_when_left_alt_is_pressed = true,

	-- default_prog = {
	-- 	"/bin/zsh",
	-- 	"--login",
	-- 	"-c",
	-- 	[[
	--    if command -v tmux >/dev/null 2>&1; then
	--      tmux attach || tmux new;
	--    else
	--      exec zsh;
	--    fi
	--    ]],
	-- },
	keys = {
		{
			key = "f",
			mods = "CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
	},

	-- Color scheme follows macOS light/dark appearance (see appearance_settings above)
	-- Catppuccin Frappé/Mocha/Latte and Rosé Pine Moon kept here as alternatives
	-- color_scheme = "Catppuccin Frappé (Gogh)",
	-- color_scheme = "Catppuccin Mocha (Gogh)",
	-- color_scheme = "Catppuccin Latte (Gogh)",
	-- color_scheme = "Rosé Pine Moon (Gogh)",
	color_scheme = initial_settings.color_scheme,

	-- Removes the macos bar at the top with the 3 buttons
	window_decorations = "RESIZE",

	-- Blur
	macos_window_background_blur = initial_settings.macos_window_background_blur, -- 95 dark, 99 light

	-- Opacity
	window_background_opacity = initial_settings.window_background_opacity, -- 0.60 dark, 0.30 light

	font_size = 13.5,

	enable_tab_bar = false,

	window_close_confirmation = "NeverPrompt",

	-- Dark mode gets a custom background color; light mode (Rosé Pine Dawn)
	-- uses the scheme's own background. See appearance_settings above.
	colors = initial_settings.colors,
	--[[ colors = {
		-- -- Kopicat
		-- foreground = "#CDD6F4",
		background = "#1f2227",
		-- background = "#111419",
		-- background = "#0a0505",
		-- selection_fg = "#9cd1bb",
		-- selection_bg = "#F5E0DC",
		-- cursor_fg = "#fcfcfa",
		-- cursor_border = "#9cd1bb",
		-- scrollbar_thumb = "#8E95B3",
		-- split = "#D0B1C8",
		--
		-- ansi = {
		-- 	"#30303b",
		-- 	"#ff657a",
		-- 	"#a8be81",
		-- 	"#eccc81",
		-- 	"#5d81ab",
		-- 	"#ebbcba",
		-- 	"#9cd1bb",
		-- 	"#fcfcfa",
		-- },
		--
		-- brights = {
		-- 	"#8E95B3",
		-- 	"#ff657a",
		-- 	"#a8be81",
		-- 	"#eccc81",
		-- 	"#5d81ab",
		-- 	"#ebbcba",
		-- 	"#9cd1bb",
		-- 	"#A1A8C9",
		-- },

		-- Default backgrounds
		-- foreground = "#CDD6F4",
		-- background = "#0a0505",
		--
		-- ansi = {
		-- 	"#0a0505",
		-- 	"#F29BA7",
		-- 	"#a8be81",
		-- 	"#F3DDA0",
		-- 	"#86AACC",
		-- 	"#D0B1C8",
		-- 	"#C9E4F6",
		-- 	"#E3F2FA",
		-- },
		--
		-- brights = {
		-- 	"#1c1d22",
		-- 	"#EA7A95",
		-- 	"#a8be81",
		-- 	"#eccc81",
		-- 	"#5d81ab",
		-- 	"#b18eab",
		-- 	"#A6C9E5",
		-- 	"#FBF1F5",
		-- },
		--
		-- 		-- When the IME, a dead key or a leader key are being processed and are effectively
		-- 		-- holding input pending the result of input composition, change the cursor
		-- 		-- to this color to give a visual cue about the compose state.
		-- 		compose_cursor = "orange",
		--
		-- 		-- Colors for copy_mode and quick_select
		-- 		-- available since: 20220807-113146-c2fee766
		-- 		-- In copy_mode, the color of the active text is:
		-- 		-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
		-- 		-- 2. selection_* otherwise
		-- 		copy_mode_active_highlight_bg = { Color = "#000000" },
		-- 	},
	}, ]]
}
-- return the configuration to wezterm
return config
