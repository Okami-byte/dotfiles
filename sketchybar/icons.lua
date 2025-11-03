local settings = require("settings")

local icons = {
	sf_symbols = {
		plus = "􀅼",
		loading = "􀖇",
		apple = "󰀶 ",
		gear = "􀍟",
		cpu = "􀫥",
		calendar = "􀉉",
		clipboard = "􀉄",
		settings = "􀣋",
		restart = "􀚁",
		stop = "􀜪",
		pencil = "􀈊",
		ram = "􀫦",
		circle_restart = "􂣽",
		circle_shutdown = "􀆨",
		circle_sleep = "􀆹",
		circle_power = "􀆨",
		circle_quit = "􀆧",
		user = "􀉪",
		search = "􀊫",
		coffee_on = "􂊭",
		coffee_off = "􀸘",
		bluetooth = "󰂯 ",
		control_center = "􀜊",
		brew = "􀐛",
		brew_check = "􀆅",

		-- App launchers and utilities
		lm_studio = "􀞏",
		onepassword = "􀎦",
		quantumultx = "􀋞",
		synergy = "􀈳",
		time_machine = "􀣔 ",
		lock = "􀎡",
		translate = "🔍",
		ubuntu = "ⓤ",

		-- Weather
		weather = {
			sun = "􀆬",
			cloudy = "􀇣",
			cloud_sun = "􀇕",
			rain = "􁷍",
			snowflake = "􀇏",
			bolt = "􀇟",
			fog = "􀇋",
			mist = "􁃛",
			cloud_rain = "􀇇",
		},

		switch = {
			-- on = "􁏮",
			-- off = "􁏯",

			-- on = "󰍜",
			-- on = "􀱢",
			on = "􀯮",
			off = "􀯯",
			-- off = "􁚬",
		},
		zen = {
			off = " 􀆺",
			on = " 􀆹",
		},

		volume = {
			_100 = "􀊩",
			_66 = "􀊧",
			_33 = "􀊥",
			_10 = "􀊡",
			_0 = "􀊣",
		},

		battery = {
			_100 = "􀛨",
			_75 = "􀺸",
			_50 = "􀺶",
			_25 = "􀛩",
			_0 = "􀛪",
			charging = "􀢋",
		},

		wifi = {
			upload = "􀄨",
			download = "􀄩",
			connected = "􀙇",
			disconnected = "􀙈",
			-- connected = "􀤆",
			-- disconnected = "􁣡",
			router = "􁓤",
			vpn = "􀎡",
			test = "",
		},

		media = {
			back = "􀊊",
			forward = "􀊌",
			play_pause = "􀊈",
			play = "􀊄",
			pause = "􀊆",
		},
	},
}

return icons.sf_symbols
