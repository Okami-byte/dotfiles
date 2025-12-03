local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("graph", "widgets.ram", 42, {
	position = "right",
	graph = { color = colors.blue },
	background = {
		height = 22,
		color = { alpha = 0 },
		border_color = { alpha = 0 },
		drawing = true,
	},
	icon = { string = icons.ram },
	label = {
		string = "ram ??%",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		align = "right",
		padding_right = 0,
		width = 0,
		y_offset = 4,
	},
	update_freq = 3,
	updates = true,
	padding_right = settings.paddings + 6,
})

sbar.add("bracket", "widgets.ram.bracket", { ram.name }, {
	background = { color = colors.bg },
})

sbar.add("item", "widgets.ram.padding", {
	position = "right",
	width = settings.group_paddings,
})

ram:subscribe({ "routine", "forced", "system_woke" }, function(env)
	sbar.exec("memory_pressure", function(output)
		local percentage = output:match("System%-wide memory free percentage: (%d+)")
		local load = 100 - tonumber(percentage)
		ram:push({ load / 100. })
		local color = colors.blue
		if load > 30 then
			if load < 60 then
				color = colors.yellow
			elseif load < 80 then
				color = colors.orange
			else
				color = colors.red
			end
		end
		ram:set({
			graph = { color = color },
			label = { string = "ram " .. load .. "%" },
		})
	end)

	ram:subscribe("mouse.clicked", function(env)
		sbar.exec("open -a 'Activity Monitor'")
	end)
end)
