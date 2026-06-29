local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local lock = sbar.add("item", "lock", {
	position = "right",
	icon = {
		string = icons.lock,
		padding_right = 10,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Regular"],
			size = 16.0,
		},
		color = colors.white,
	},
	label = { drawing = false },
	background = { drawing = false },
	padding_left = settings.paddings,
	padding_right = settings.paddings,
	updates = true,
})

lock:subscribe("mouse.entered", function(_)
	lock:set({ icon = { color = colors.red } })
end)

lock:subscribe("mouse.exited", function(_)
	lock:set({ icon = { color = colors.white } })
end)

lock:subscribe("mouse.clicked", function(env)
	sbar.exec(
		[[osascript -e 'tell application "System Events" to keystroke "q" using {command down, control down}']],
		function() end
	)
end)
