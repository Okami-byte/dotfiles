local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local onepassword = sbar.add("item", "widgets.onepassword", {
	position = "right",
	icon = {
		string = app_icons["1Password"] or "",
		font = "sketchybar-app-font:Regular:16.0",
		color = colors.white,
	},
	label = { drawing = false },
	background = { drawing = false },
	padding_left = settings.paddings,
	padding_right = settings.paddings,
	updates = true,
})

onepassword:subscribe("mouse.entered", function(env)
	onepassword:set({ icon = { color = colors.blue } })
end)

onepassword:subscribe("mouse.exited", function(env)
	onepassword:set({ icon = { color = colors.white } })
end)

onepassword:subscribe("mouse.clicked", function(env)
	if env.BUTTON == "right" then
		sbar.exec("open -a '1Password'")
		return
	end

	onepassword:set({ icon = { color = colors.blue } })
	sbar.exec("osascript -e 'tell application \"System Events\" to key code 49 using {command down, shift down}'")
	sbar.delay(0.10, function()
		onepassword:set({ icon = { color = colors.white } })
	end)
end)
