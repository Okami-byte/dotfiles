local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local control_center = sbar.add("item", "control_center", {
	position = "right",
	padding_right = -7,
	padding_left = 7,
	icon = {
		drawing = true,
		string = icons.control_center,
		font = { size = 14 },
		color = colors.white,
	},
	background = {
		drawing = false,
	},
	click_script = 'osascript -e \'tell application "System Events" to tell process "ControlCenter" to click menu bar item 2 of menu bar 1\'',
})
