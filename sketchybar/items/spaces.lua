local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
-- local sino_korean = { "일", "이", "세", "사", "오", "의", "리", "네", "세", "예" }
-- local japanese = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" }

for i = 1, 10, 1 do
	local space = sbar.add("space", "space." .. i, {
		position = "left",
		space = i,
		icon = {
			font = { family = settings.font.icons },
			-- string = sino_korean[i],
			-- string = japanese[i],
			string = i,
			padding_left = 15,
			padding_right = 8,
			color = colors.arise,
			highlight_color = colors.hollow,
			align = "center",
		},
		label = {
			padding_right = 20,
			color = colors.grey,
			highlight_color = colors.white,
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = 0,
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			color = colors.bg1,
			border_width = 1,
			height = 26,
			border_color = colors.grey,
		},
		popup = { background = { border_width = 5, border_color = colors.grey } },
	})

	spaces[i] = space

	-- Single item bracket for space items to achieve double border on highlight
	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = 28,
			border_width = 2,
		},
	})

	-- Padding space
	sbar.add("space", "space.padding." .. i, {
		space = i,
		script = "",
		width = settings.group_paddings,
	})

	local space_popup = sbar.add("item", {
		position = "popup." .. space.name,
		padding_left = 5,
		padding_right = 0,
		background = {
			drawing = true,
			image = {
				corner_radius = 9,
				scale = 0.2,
			},
		},
	})

	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		local color = selected and colors.white or colors.bg2
		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
			background = { border_color = selected and colors.grey or colors.bg2 },
		})
		space_bracket:set({
			background = { border_color = selected and colors.arise or colors.bg2 },
		})
	end)

	space:subscribe("mouse.clicked", function(env)
		if env.BUTTON == "other" then
			space_popup:set({ background = { image = "space." .. env.SID } })
			space:set({ popup = { drawing = "toggle" } })
		else
			local op = (env.BUTTON == "right") and "--destroy" or "--focus"
			sbar.exec("yabai -m space " .. op .. " " .. env.SID)
		end
	end)

	space:subscribe("mouse.exited", function(_)
		space:set({ popup = { drawing = false } })
	end)
end

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Menu",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

-- Superscript mapping for window counts
local SUPERSCRIPTS = {
	["0"] = "⁰",
	["1"] = "¹",
	["2"] = "²",
	["3"] = "³",
	["4"] = "⁴",
	["5"] = "⁵",
	["6"] = "⁶",
	["7"] = "⁷",
	["8"] = "⁸",
	["9"] = "⁹",
}

-- Convert a number to superscript Unicode characters
local function to_superscript(num)
	return tostring(num):gsub(".", function(digit)
		return SUPERSCRIPTS[digit] or digit
	end)
end

-- Format a single app: superscript count before icon
local function to_formatted_icon(app, count)
	local icon = app_icons[app] or app_icons["Default"]
	-- Put the superscript BEFORE the icon with a space after it
	local count_str = count > 1 and (to_superscript(count) .. " ") or ""
	return count_str .. icon
end

space_window_observer:subscribe("space_windows_change", function(env)
	-- Build formatted icons for each app
	local formatted_icons = {}
	for app, count in pairs(env.INFO.apps) do
		table.insert(formatted_icons, to_formatted_icon(app, count))
	end

	-- Join with hair space between app groups for tighter spacing
	local icon_line = #formatted_icons > 0 and table.concat(formatted_icons, "\u{200A}") or "—"

	-- Animate the label update
	sbar.animate("tanh", 30, function()
		spaces[env.INFO.space]:set({ label = icon_line })
	end)
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
		label = {
			string = currently_on and "Spaces" or "Menu",
		},
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.black },
			label = {
				color = colors.black,
				width = "dynamic",
			},
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
