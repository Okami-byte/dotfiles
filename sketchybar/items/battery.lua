local popup = require("helpers/popup")

local mod = {}

local popup_width = 220

-- Setup
function mod.setup(icons, palette)
	mod.properties = {
		position = "right",
		icon = {
			string = icons.battery.p100,
			font = { style = "Regular", size = 16.0 },
		},
		popup = { align = "center" },
	}
	return mod
end

local function update(item, icons, palette)
	return function(env)
		sbar.exec("pmset -g batt | grep 'not charging'", function(result_charging, exit_code_charging)
			sbar.exec("pmset -g batt | grep 'AC Power'", function(result_ac, exit_code_ac)
				sbar.exec('pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1', function(result, exit_code)
					local percentage = tonumber(result)

					local properties = { icon = {}, label = { string = percentage .. " %" } }

					-- Icon
					if exit_code_ac == 0 then
						properties.icon.string = icons.battery.ac
					elseif percentage < 10 then
						properties.icon.string = icons.battery.p0
					elseif percentage < 30 then
						properties.icon.string = icons.battery.p25
					elseif percentage < 60 then
						properties.icon.string = icons.battery.p50
					elseif percentage < 90 then
						properties.icon.string = icons.battery.p75
					else
						properties.icon.string = icons.battery.p100
					end

					-- Color
					if exit_code_charging == 1 then -- exit_code = 0 -> not charging 1 -> charging
						if exit_code_ac == 0 then
							properties.icon.color = palette.colors.purple
						elseif percentage < 10 then
							properties.icon.color = palette.colors.red
						elseif percentage < 30 then
							properties.icon.color = palette.colors.orange
						elseif percentage < 60 then
							properties.icon.color = palette.colors.yellow
						elseif percentage < 90 then
							properties.icon.color = palette.colors.blue
						else
							properties.icon.color = palette.colors.cyan
						end
					else
						properties.icon.color = palette.text.subtle
					end

					item:set(properties)
				end)
			end)
		end)
	end
end

local function add_popup_items(item)
	mod.percentage = sbar.add("item", {
		position = "popup." .. item.name,
		icon = { align = "left", string = "Percentage:", width = popup_width / 2 },
		label = { align = "right", string = "…", width = popup_width / 2 },
		background = { color = 0x00000000 },
	})

	mod.remaining = sbar.add("item", {
		position = "popup." .. item.name,
		icon = { align = "left", string = "Time remaining:", width = popup_width / 2 },
		label = { align = "right", string = "…", width = popup_width / 2 },
		background = { color = 0x00000000 },
	})

	mod.condition = sbar.add("item", {
		position = "popup." .. item.name,
		icon = { align = "left", string = "Battery condition:", width = popup_width / 2 },
		label = { align = "right", string = "…", width = popup_width / 2 },
		background = { color = 0x00000000 },
	})

	mod.capacity = sbar.add("item", {
		position = "popup." .. item.name,
		icon = { align = "left", string = "Maximum capacity:", width = popup_width / 2 },
		label = { align = "right", string = "…", width = popup_width / 2 },
		background = { color = 0x00000000 },
	})
end

local function fetch_details()
	sbar.exec("pmset -g batt", function(batt_info)
		local found, _, charge = batt_info:find("(%d+)%%")
		mod.percentage:set({ label = { string = found and (charge .. "%") or "N/A" } })

		local found_time, _, remaining = batt_info:find("(%d+:%d+) remaining")
		local charging = batt_info:find("AC Power") ~= nil
		local icon = charging and "Time till full:" or "Time remaining:"
		local label = found_time and (remaining .. "h") or "No estimate"
		mod.remaining:set({ icon = { string = icon }, label = { string = label } })
	end)

	sbar.exec("system_profiler SPPowerDataType", function(batt_info)
		local found, _, condition = batt_info:find("Condition: (%a+)")
		mod.condition:set({ label = { string = found and condition or "Unknown" } })

		local found_cap, _, capacity = batt_info:find("Maximum Capacity: (%d+)%%")
		mod.capacity:set({ label = { string = found_cap and (capacity .. "%") or "Unknown" } })
	end)
end

-- Load
function mod.load(icons, palette)
	-- Check for battery presence
	local percentage = tonumber(shellEval('pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1'))
	if percentage then
		mod.item = sbar.add("item", mergeTables(mod.properties, { label = { string = percentage .. " %" } }, false))
		popup.register(mod.item)

		mod.item:set({
			popup = {
				background = {
					color = 0xff101010,
					corner_radius = 10,
					border_width = 1,
					border_color = palette.zone.border,
				},
			},
		})

		add_popup_items(mod.item)

		mod.item:subscribe({ "power_source_change", "routine", "forced" }, update(mod.item, icons, palette))
		mod.item:subscribe("mouse.clicked", function(env)
			popup.toggle(mod.item, fetch_details)
		end)
		popup.auto_hide(mod.item)
	else
		log("battery", "No battery detected.")
	end

	return mod
end

return mod
