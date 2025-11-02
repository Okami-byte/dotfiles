local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	height = 35,
	topmost = "off",
	color = colors.bar.bg,
	border_width = 2,
	border_color = colors.bar.border,
	padding_right = 2,
	padding_left = 2,
	corner_radius = 10,
	blur_radius = 15,
	y_offset = 4,
	margin = 10,
})
