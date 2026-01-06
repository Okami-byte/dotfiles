return {
	--- catppuccin
	black = 0xff11111b,
	white = 0xffe2e2e3,
	red = 0xffe78284,
	maroon = 0xffeba0ac,
	green = 0xffa6d189,
	lime = 0xff32cd32,
	leaf = 0xff30B700,
	blue = 0xff8caaee,
	cyan = 0xffb2fdff,
	teal = 0xff00B5B8,
	sapphire = 0xff85c1dc,
	arise = 0xffe6f8f7,
	yellow = 0xffe7c664,
	gold = 0xffe7b744,
	orange = 0xfff5a97f,
	mauve = 0xffcba6f7,
	lavender = 0xffb4befe,
	purple = 0xff917ae7,
	violet = 0xff7d4a95,
	pink = 0xfff5bde6,
	grey = 0xff7f8490,
	hollow = 0xff9cb0da,
	transparent = 0x00000000,

	--- rose-pine
	-- black = 0xff191724, --nc
	-- light_grey = 0xff6e6a86, --
	-- grey = 0xff908caa,
	-- white = 0xffe0def4, --text
	-- red = 0xffeb6f92, --love
	-- yellow = 0xfff6c177, --gold
	-- orange = 0xfff39660,
	-- maroon = 0xffeba0ac,
	-- flamingo = 0xfff2cdcd,
	-- sapphire = 0xff74c7ec,
	-- pink = 0xffebbcba, --rose
	-- peach = 0xfff5a97f,
	-- blue = 0xff31748f, --pine
	-- foam = 0xff9ccfd8, --foam
	-- purple = 0xffc4a7e7, --iris
	-- green = 0xff95b1ac, --leaf
	-- arise = 0xffe6f8f7,
	-- transparent = 0x00000000,

	bar = {
		-- bg = 0x00000000, -- Transparent background
		-- bg = 0x00ffffff, -- Different Transparent background
		-- bg = 0xf02c2e34, -- Grey Transparent
		-- bg = 0x80414354, -- Light Transparent
		-- bg = 0xff414141,
		-- bg = 0x991c1c1c, -- Mostly dark transparent
		-- bg = 0xf0181819, -- Black Transparent
		-- bg = 0xff11111b, -- crust
		bg = 0xB81f1f30,
		border = 0xB845475a,
		-- border = 0xff414141, -- mantle	-- border = 0xff2c2e34,

		blur_radius = 80,
	},
	popup = {
		-- bg = 0x991c1c1c,
		bg = 0xB81f1f30,
		border = 0xff414141,
		blur_radius = 60,
	},
	bg1 = 0xff363944,
	bg2 = 0xff414550,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
	transparency = 0.9,
}
