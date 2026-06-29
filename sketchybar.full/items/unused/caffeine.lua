local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local caffeine = sbar.add("item", "widgets.caffeine", {
	position = "right",
	icon = {
		font = {
			style = settings.font["Regular"],
			size = 15,
		},
		padding_right = 2,
	},
	label = { drawing = true },
	update_freq = 30,
})

local function update_caffeine_status()
	sbar.exec(
		"pmset -g assertions | grep \"caffeinate\" | awk '{print $2}' | cut -d '(' -f1 | head -n 1",
		function(result)
			local caffinate_id = result:gsub("%s+", "")

			if caffinate_id == "" then
				caffeine:set({
					icon = {
						string = icons.coffee_off,
						color = colors.grey,
					},
				})
			else
				caffeine:set({
					icon = {
						string = icons.coffee_on,
						color = colors.green,
					},
				})
			end
		end
	)
end

caffeine:subscribe({ "routine", "forced" }, update_caffeine_status)

caffeine:subscribe("mouse.clicked", function(env)
	sbar.exec(
		"pmset -g assertions | grep \"caffeinate\" | awk '{print $2}' | cut -d '(' -f1 | head -n 1",
		function(result)
			local caffinate_id = result:gsub("%s+", "")

			if caffinate_id == "" then
				-- Start caffeinate
				sbar.exec("caffeinate -id &")
				caffeine:set({
					icon = {
						string = icons.coffee_on,
						color = colors.green,
					},
				})
			else
				-- Kill caffeinate
				sbar.exec("kill -9 " .. caffinate_id)
				caffeine:set({
					icon = {
						string = icons.coffee_off,
						color = colors.grey,
					},
				})
			end
		end
	)
end)

-- Initial status update
update_caffeine_status()

sbar.add("bracket", "widgets.caffeine.bracket", { caffeine.name }, {
	background = { color = colors.bg },
})

sbar.add("item", "widgets.caffeine.padding", {
	position = "right",
	width = 0,
})
