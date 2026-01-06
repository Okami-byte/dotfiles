local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "widgets.battery", {
	position = "right",
	icon = {
		font = {
			style = settings.font.style_map["Regular"],
			size = 19.0,
		},
	},
	label = { drawing = false }, -- { font = { family = settings.font.numbers } },
	update_freq = 180,
	popup = { align = "center" },
})

local battery_percent = sbar.add("item", {
	position = "popup." .. battery.name,
	icon = {
		string = "Percentage:",
		width = 100,
		align = "left",
	},
	label = {
		string = "??%",
		width = 100,
		align = "right",
	},
})

local remaining_time = sbar.add("item", {
	position = "popup." .. battery.name,
	icon = {
		string = "??",
		width = 100,
		align = "left",
	},
	label = {
		string = "??:??h",
		width = 100,
		align = "right",
	},
})

local battery_condition = sbar.add("item", {
	position = "popup." .. battery.name,
	icon = {
		string = "Battery condition:",
		width = 100,
		align = "left",
	},
	label = {
		string = "Normal",
		width = 100,
		align = "right",
	},
})

local battery_capacity = sbar.add("item", {
	position = "popup." .. battery.name,
	icon = {
		string = "Maximum capacity:",
		width = 100,
		align = "left",
	},
	label = {
		string = "86%",
		width = 100,
		align = "right",
	},
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
	sbar.exec("pmset -g batt", function(batt_info)
		local icon = "!"
		local label = "?"

		local found, _, charge = batt_info:find("(%d+)%%")
		if found then
			charge = tonumber(charge)
			label = charge .. "%"
		end

		local color = colors.green
		local charging, _, _ = batt_info:find("AC Power")

		if charging then
			icon = icons.battery.charging
		else
			if found and charge > 80 then
				icon = icons.battery._100
			elseif found and charge >= 65 then
				icon = icons.battery._75
				color = colors.leaf
			elseif found and charge >= 50 then
				icon = icons.battery._50
				color = colors.yellow
			elseif found and charge >= 20 then
				icon = icons.battery._25
				color = colors.orange
			else
				icon = icons.battery._0
				color = colors.red
			end
		end

		local lead = ""
		if found and charge < 10 then
			lead = "0"
		end

		battery:set({
			icon = {
				string = icon,
				color = color,
			},
			label = { string = lead .. label },
		})
	end)
end)

battery:subscribe("mouse.clicked", function(env)
	local drawing = battery:query().popup.drawing
	battery:set({ popup = { drawing = "toggle" } })

	if drawing == "off" then
		sbar.exec("pmset -g batt", function(batt_info)
			local found, _, charge = batt_info:find("(%d+)%%")
			if found then
				battery_percent:set({ label = charge .. "%" })
			else
				battery_percent:set({ label = "N/A" })
			end

			local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
			local label = found and remaining .. "h" or "No estimate"

			local charging, _, _ = batt_info:find("AC Power")
			local icon = charging and "Time till full:" or "Time remaining:"
			remaining_time:set({ icon = icon, label = label })
		end)

		sbar.exec("system_profiler SPPowerDataType", function(batt_info)
			local found, _, condition = batt_info:find("Condition: (%a+)")
			local label = found and condition or "Unknown"
			battery_condition:set({ label = label })

			local found, _, capacity = batt_info:find("Maximum Capacity: (%d+)%%")
			local label = found and capacity .. "%" or "Unknown"
			battery_capacity:set({ label = label })
		end)
	end
	-- A right click button in order to open up network preferences
	if env.BUTTON == "right" then
		sbar.exec(
			'osascript -e \'tell application "System Events" to tell process "Battery Toolkit" to click menu bar item 1 of menu bar 2\''
		)
		return
	end
end)

battery:subscribe("mouse.exited.global", function()
	battery:set({ popup = { drawing = "off" } })
end)

sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
	background = { color = colors.bg },
})

sbar.add("item", "widgets.battery.padding", {
	position = "right",
	width = settings.group_paddings,
})
