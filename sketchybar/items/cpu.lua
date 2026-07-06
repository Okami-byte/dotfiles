local mod = {}

local GRAPH_WIDTH = 75
local PERCENT_WIDTH = 24
local ICON_WIDTH = 18

-- Setup
function mod.setup(bar, palette)
	local graph_margin = math.floor(bar.config.height / 8)

	mod.config = {
		graph_margin = graph_margin,
		update_freq = config.cpu_update_freq or 2,
	}

	mod.properties = {
		graph = {
			position = "e",
			drawing = false,

			padding_left = 0,
			padding_right = -45,
			y_offset = -(bar.config.height / 2) + graph_margin + 7,

			graph = { color = palette.text.subtle },

			icon = { drawing = false },
			label = { drawing = false },

			background = {
				drawing = true,
				padding_left = 4,
				padding_right = 0,
				height = bar.config.height - graph_margin * 2 - 9,
			},
		},

		percent = {
			position = "e",
			drawing = false,

			padding_left = 6,
			padding_right = 0,
			y_offset = -(bar.config.height / 2) + graph_margin + 8,

			-- icon = {
			-- 	string = "",
			-- 	drawing = true,
			-- 	color = palette.text.subtle,
			-- 	width = ICON_WIDTH,
			-- 	padding_left = 0,
			-- 	padding_right = 0,
			-- 	font = { family = config.font, style = "Regular", size = 10.0 },
			-- },

			label = {
				string = "0%",
				drawing = true,
				width = PERCENT_WIDTH,
				padding_left = 0,
				padding_right = 0,
				font = { family = config.font, style = "Bold", size = 10.0 },
			},

			background = { drawing = false },
		},

		label = {
			position = "e",
			drawing = false,

			-- Negative paddings pull the item back to overlap the graph+percent area.
			-- Account for icon width so the top text aligns with the widget's left edge.
			padding_left = -(PERCENT_WIDTH + ICON_WIDTH),
			padding_right = -GRAPH_WIDTH,
			y_offset = math.floor(bar.config.height / 2) - graph_margin - 5,

			icon = { drawing = false },

			label = {
				string = "CPU",
				drawing = true,
				width = GRAPH_WIDTH + PERCENT_WIDTH + ICON_WIDTH,
				padding_left = 0,
				padding_right = 0,
				color = palette.text.subtle,
				font = { family = config.font, style = "Regular", size = 7.0 },
			},

			background = { drawing = false },
		},
	}

	mod.shell_colors = {
		red = string.format("0x%08x", palette.colors.red),
		orange = string.format("0x%08x", palette.colors.orange),
		yellow = string.format("0x%08x", palette.colors.yellow),
		blue = string.format("0x%08x", palette.colors.blue),
		subtle = string.format("0x%08x", palette.text.subtle),
	}

	return mod
end

-- Load
function mod.load(separator, palette)
	mod.graph = sbar.add("graph", "cpu_graph", GRAPH_WIDTH, mod.properties.graph)
	mod.graph_percent = sbar.add("item", "cpu_percent", mod.properties.percent)
	mod.graph_label = sbar.add("item", "cpu_label", mod.properties.label)

	mod.visible = false

	-- Toggle visibility from the zone separator's right-click
	function mod.toggle(separator, icons)
		mod.visible = not mod.visible

		if mod.visible then
			mod.graph:set({ drawing = true })
			mod.graph_percent:set({ drawing = true })
			mod.graph_label:set({ drawing = true })
			separator:set({
				icon = {
					string = "􀫰",
					font = { family = config.font, style = "Semibold", size = 14.0 },
					padding_left = 4,
					padding_right = 4,
					y_offset = 0,
				},
			})
		else
			mod.graph:set({ drawing = false })
			mod.graph_percent:set({ drawing = false })
			mod.graph_label:set({ drawing = false })
			separator:set({ icon = icons.zones.collapsed })
		end
	end

	local c = mod.shell_colors
	local freq = mod.config.update_freq

	-- Use placeholder substitution instead of string.format so that awk % signs
	-- (e.g. gsub(/%/,...)) don't get misinterpreted as Lua format specifiers.
	local script = ([[
		#SKETCHYBAR_CPU_LOOP#

		lastpid=$(cat "${TMPDIR}sketchybar/cpu_pid" 2>/dev/null || echo 0)
		if ps -p "$lastpid" -o command= 2>/dev/null | grep -q '#SKETCHYBAR_CPU_LOOP#'; then
			kill -9 "$lastpid" 2>/dev/null
		fi
		mkdir -p "${TMPDIR}sketchybar"
		echo $$ > "${TMPDIR}sketchybar/cpu_pid"

		while true; do
			pct=$(top -l1 -n1 2>/dev/null \
				| awk '/CPU usage/{gsub(/%/,""); printf "%.0f", $3+$5}')
			[ -z "$pct" ] && pct=0

			if   [ "$pct" -ge 75 ]; then color=CLRED
			elif [ "$pct" -ge 50 ]; then color=CLORANGE
			elif [ "$pct" -ge 25 ]; then color=CLYELLOW
			elif [ "$pct" -ge  5 ]; then color=CLBLUE
			else                         color=CLSUBTLE
			fi

			point=$(echo "$pct" | awk '{printf "%.4f", $1/100}')
			proc=$(/bin/ps -Aceo pid,pcpu,comm -r 2>/dev/null \
				| awk 'NR==2{printf "%s%% - %s [%s]",$2,$3,$1}')

			sketchybar \
				--push cpu_graph  "$point" \
				--set  cpu_graph   graph.color="$color" \
				--set  cpu_percent icon.color="$color" label="${pct}%" \
				--set  cpu_label   label="$proc" label.color="$color"

			sleep FREQ
		done
	]]):gsub("CLRED", c.red):gsub("CLORANGE", c.orange):gsub("CLYELLOW", c.yellow):gsub("CLBLUE", c.blue):gsub(
		"CLSUBTLE",
		c.subtle
	):gsub("FREQ", tostring(freq))

	sbar.exec(script, function(_, exit_code)
		log("cpu-loop", "Exited: " .. tostring(exit_code))
	end)

	return mod
end

return mod
