local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
	icon = {
		color = colors.arise,
		padding_left = 4,
		font = {
			style = settings.font.style_map["Black"],
			size = 12.0,
		},
	},
	label = {
		color = colors.peach,
		padding_right = 10, -- Padding is a bit uneven in order to match apple icon on the left
		width = 45,
		align = "right",
		font = { family = settings.font.numbers },
	},
	position = "right",
	update_freq = 30,
	padding_left = 1,
	padding_right = 1,
	background = {
		color = colors.transparent,
		border_color = colors.transparent,
		border_width = 1,
	},
	click_script = "open -a 'Notion Calendar'",
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
	background = {
		color = colors.transparent,
		height = 30,
		border_color = colors.transparent,
	},
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = os.date("%a. %d %b "), label = os.date(" %H:%M") })
end)
