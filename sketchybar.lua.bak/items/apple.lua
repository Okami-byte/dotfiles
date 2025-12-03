local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local popup_width = 200
-- Main apple icon to trigger popup

-- Padding item required because of bracket
sbar.add("item", { width = 5 })

local apple = sbar.add("item", {
	icon = {
		font = { size = 22.0 },
		string = icons.apple,
		color = colors.arise,
		padding_right = 1,
		padding_left = 5,
		border_color = colors.transparent,
	},
	label = { drawing = true },
	popup = {
		align = "left",
		horizontal = false,
		height = "static",
		width = popup_width,
	},
})

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
	background = {
		color = colors.bg,
		height = 30,
		-- Border around apple symbol
		border_color = colors.bg,
	},
})

-- Padding item required because of bracket
sbar.add("item", { width = 3 })

-- Helper function to create menu items with hover effect
local function create_menu_item(position, label, icon_string, click_command)
	local item = sbar.add("item", {
		position = position,
		icon = {
			string = icon_string,
			padding_left = 5,
			padding_right = 15,
			color = colors.arise,
		},
		label = {
			string = label,
			color = colors.arise,
			padding_left = 5,
			padding_right = 20,
			align = "left",
			font = { size = 12 },
		},
		background = {
			padding_left = 10,
			padding_right = 15,
			color = colors.transparent,
			border_color = colors.transparent,
			height = 40, -- Reduced height for compactness
			width = popup_width,
		},
		click_script = click_command,
	})

	-- Hover effect
	item:subscribe("mouse.entered", function()
		sbar.animate("elastic", 5, function()
			item:set({
				icon = {
					padding_left = 5,
					padding_right = 15,
					color = colors.purple,
					font = { size = 16 },
				},
				label = {
					color = colors.grey,
					padding_left = 10,
					padding_right = 20,
					align = "left",
					font = { size = 12, style = "Bold" },
				},
			})
		end)
	end)
	item:subscribe("mouse.exited", function()
		sbar.animate("elastic", 15, function()
			item:set({
				icon = {
					padding_left = 5,
					padding_right = 15,
					font = { size = 14 },
					color = colors.arise,
				},
				label = {
					padding_left = 10,
					padding_right = 20,
					string = label,
					color = colors.arise,
					align = "left",
					font = { size = 12 },
				},
			})
		end)
	end)

	return item
end

-- Add each custom menu entry to the popup
local about_mac = create_menu_item("popup." .. apple.name, "About", icons.user, "open -a 'About This Mac'")
local system_settings = create_menu_item("popup." .. apple.name, "Settings", icons.gear, "open -a 'System Preferences'")
local force_quit = create_menu_item(
	"popup." .. apple.name,
	"Force Quit",
	icons.circle_quit,
	'osascript -e \'tell application "System Events" to keystroke "q" using {command down}\''
)
-- local sleep = create_menu_item("popup." .. apple.name, "Sleep", icons.circle_sleep, "pmset displaysleepnow")
local restart = create_menu_item(
	"popup." .. apple.name,
	"Restart",
	icons.circle_restart,
	"osascript -e 'tell app \"System Events\" to restart'"
)
local shutdown = create_menu_item(
	"popup." .. apple.name,
	"Power off",
	icons.circle_shutdown,
	"osascript -e 'tell app \"System Events\" to shut down'"
)

-- Toggles popup on click
apple:subscribe("mouse.clicked", function(env)
	sbar.animate("elastic", 15, function()
		apple:set({
			popup = {
				y_offset = 0,
				height = 0,
				drawing = "toggle",
			},
		})
	end)
end)

-- Hides popup on mouse exit
apple:subscribe("mouse.exited.global", function(env)
	sbar.animate("elastic", 15, function()
		apple:set({
			popup = {
				y_offset = -10,
				height = 0,
				drawing = false,
			},
		})
	end)
end)

return apple
