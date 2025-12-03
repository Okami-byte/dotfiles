local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local settings_widget = sbar.add("item", "widgets.settings", {
	position = "right",
	icon = { string = icons.settings, padding_left = 0 },
	label = { drawing = false },
	popup = { align = "center", height = 35 },
})

local restart = sbar.add("item", {
	position = "popup." .. settings_widget.name,
	icon = { string = icons.restart },
	label = { string = "Restart" },
})

restart:subscribe("mouse.clicked", function()
	sbar.exec("sketchybar --reload")
end)

local stop = sbar.add("item", {
	position = "popup." .. settings_widget.name,
	icon = { string = icons.stop },
	label = { string = "Stop" },
})

stop:subscribe("mouse.clicked", function()
	sbar.exec("brew services stop sketchybar")
end)

local edit_configuration = sbar.add("item", {
	position = "popup." .. settings_widget.name,
	icon = { string = icons.pencil },
	label = { string = "Edit Config" },
})

edit_configuration:subscribe("mouse.clicked", function()
	sbar.exec(
		'osascript -e \'tell application "Terminal" to if (count of windows) = 0 then reopen\' -e \'tell application "Terminal" to activate\' -e \'tell application "Terminal" to do script "cd ~/.config/sketchybar && nvim " in front window\''
	)
end)

local system_settings = sbar.add("item", {
	position = "popup." .. settings_widget.name,
	icon = { string = icons.gear },
	label = { string = "System Settings" },
})

system_settings:subscribe("mouse.clicked", function()
	sbar.exec("open -a System\\ Settings")
end)

sbar.add("bracket", "widgets.settings.bracket", { settings_widget.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "widgets.settings.padding", {
	position = "right",
	width = settings.group_paddings,
})

settings_widget:subscribe("mouse.clicked", function()
	settings_widget:set({ popup = { drawing = "toggle" } })
end)

settings_widget:subscribe("mouse.exited.global", function()
	settings_widget:set({ popup = { drawing = "off" } })
end)
