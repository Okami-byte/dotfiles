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
	-- animation_fps = 120,

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

	-- For example, changing the color scheme:
	-- color_scheme = "Catppuccin Frappé (Gogh)",
	-- color_scheme = "Catppuccin Mocha (Gogh)",
	-- color_scheme = "Rosé Pine Moon (Gogh)",
	color_scheme = "Rosé Pine (Gogh)",

	-- Removes the macos bar at the top with the 3 buttons
	window_decorations = "RESIZE",

	-- Blur
	macos_window_background_blur = 50,

	-- Opacity
	window_background_opacity = 0.65,

	-- https://wezfurlong.org/wezterm/config/lua/wezterm/font.html
	-- font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
	-- font = wezterm.font("JetBrainsMono Nerd Font"),
	-- font_size = 14.5,
	font_size = 14,

	-- I don't use tabs
	enable_tab_bar = false,

	window_close_confirmation = "NeverPrompt",

	-- -- NOTE: My cursor was not blinking when using wezterm with the "wezterm" terminfo
	-- -- Setting my term to "xterm-kitty" fixed the issue
	-- -- I also use the zsh-vi-mode plugin, I had to set up the blinking cursor
	-- -- for that in my zshrc file
	-- -- Neovim didn't need cursor changes, worked by setting it to "xterm-kitty"
	-- --
	default_cursor_style = "SteadyBlock",
	-- default_cursor_style = "BlinkingBlock",

	-- I don't like the the "Linear", which gives it a fade effect between blinks
	-- cursor_blink_ease_out = "Constant",
	-- cursor_blink_ease_in = "Constant",
	-- Setting this to 0 disables blinking
	-- cursor_blink_rate = 0,

	colors = {
		-- foreground = "#fcfcfc",
		background = "#0B0A08",
		-- background = "#100c08",
		-- background = "#353839",
		-- background = "#222222",
		-- background = "#9B96B5",
		-- background = "#444444",
		-- background = "#3c3c3c",
		-- background = "#464651",
		-- background = "#2f2f3b",
		-- cursor_bg = "#9B96B5",
		-- cursor_bg = "#FBF1F5",
		cursor_bg = "#fab387",
		-- 	-- cursor_fg = "black",
		-- cursor_border = "#fab387",
		-- selection_fg = "black",
		-- selection_bg = "#fffacd",
		-- 	scrollbar_thumb = "#222222",
		-- split = "#444444",
		--
		-- 	ansi = {
		-- 		"#6C6168",
		-- 		"#F29BA7",
		-- 		"#a8be81",
		-- 		"#F3DDA0",
		-- 		"#86AACC",
		-- 		"#D0B1C8",
		-- 		"#C9E4F6",
		-- 		"#E3F2FA",
		-- 	},
		--
		-- 	brights = {
		-- 		"#1c1d22",
		-- 		"#EA7A95",
		-- 		"#a8be81",
		-- 		"#eccc81",
		-- 		"#5d81ab",
		-- 		"#b18eab",
		-- 		"#A6C9E5",
		-- 		"#FBF1F5",
		-- 	},
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
	},
}
-- return the configuration to wezterm
return config
