local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local settings_widget = sbar.add("item", "widgets.settings", {
	position = "right",
	icon = { string = icons.settings, color = colors.green, padding_left = 0, padding_right = 12 },
	label = { drawing = false },
	popup = { align = "right", height = 35 },
})

local music = sbar.add("item", {
	position = "popup." .. settings_widget.name,
	icon = { string = icons.music, color = colors.maroon },
	label = { string = "Music" },
})

music:subscribe("mouse.clicked", function()
	sbar.exec("open -a Spotify")
end)

local play_torrio = sbar.add("item", {
	position = "popup." .. settings_widget.name,
	icon = { string = icons.playtorrio, color = colors.purple },
	label = { string = "PlayTorrio" },
})

play_torrio:subscribe("mouse.clicked", function()
	sbar.exec("open -na PlayTorrio")
end)

local weather = sbar.add("item", {
	position = "popup." .. settings_widget.name,
	icon = { string = icons.cloud, color = colors.yellow },
	label = { string = "Weather" },
})

weather:subscribe("mouse.clicked", function()
	sbar.exec("open -a weather")
end)

local wezterm = sbar.add("item", {
	position = "popup." .. settings_widget.name,
	icon = { string = icons.terminal, color = colors.hollow },
	label = { string = "Wezterm" },
})

wezterm:subscribe("mouse.clicked", function()
	sbar.exec('open -n -a "wezterm"')
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

local restart = sbar.add("item", {
	position = "popup." .. settings_widget.name,
	icon = { string = icons.restart, color = colors.blue },
	label = { string = "Reload Bar" },
})

restart:subscribe("mouse.clicked", function()
	sbar.exec("sketchybar --reload")
end)

sbar.add("bracket", "widgets.settings.bracket", { settings_widget.name }, {
	background = { color = colors.transparent, border_color = colors.transparent },
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
