local mod = {}
local app_icons = require("helpers.app_icons")

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

local function to_superscript(num)
	return tostring(num):gsub(".", function(d)
		return SUPERSCRIPTS[d] or d
	end)
end

local function to_formatted_icon(app, count)
	local icon = app_icons[app] or app_icons["default"]
	local prefix = count > 1 and (to_superscript(count) .. " ") or ""
	return prefix .. icon
end

-- Setup
function mod.setup(bar, zones, palette)
	mod.properties = {
		space = {
			padding_left = 2,
			padding_right = 2,

			icon = {
				padding_left = 6,
				padding_right = 7,
				color = palette.colors.yellow,
				highlight_color = palette.colors.red,
			},

			background = {
				height = bar.config.height - 12,
				corner_radius = zones.properties.background.corner_radius - 1,
				color = palette.zone.border,
				drawing = false,
			},

			label = {
				drawing = true,
				padding_right = 13,
				padding_left = 13,
				y_offset = -1,
				width = 0,
				font = "sketchybar-app-font:Regular:16.0",
				background = {
					drawing = true,
					height = bar.config.height - 12,
					color = palette.zone.overlay,
					corner_radius = zones.properties.background.corner_radius - 1,
				},
			},
		},
		separator = {
			padding_left = bar.config.padding - 2,
			padding_right = bar.config.padding - 2,
			associated_display = "active",

			icon = {
				string = "􀯻",
				font = { style = "Semibold", size = 14.0 },
				color = palette.text.muted,
				padding_left = 0,
				padding_right = 4,
				y_offset = 1,
			},

			label = { drawing = false },
		},
		front_app = {
			padding_left = 0,
			padding_right = 0,
			updates = true,
			associated_display = "active",

			background = {
				color = palette.zone.border,
				height = bar.config.height - 13,
				corner_radius = 7,
			},

			icon = {
				string = ":gear:",
				padding_right = 5,
				padding_left = 5,
				font = "sketchybar-app-font:Regular:15.0",
				color = palette.colors.blue,
			},

			label = {
				string = "Gloup",
				padding_left = 0,
				padding_right = 5,
				color = palette.text.primary,
				font = { style = "Black", size = 12.0 },
			},
		},
	}

	mod.space_count = 15
	mod.items = {}
	return mod
end

-- Show / hide all space items
function mod.show(bool)
	perfbc()
	mod.items["separator"]:set({ drawing = bool })

	if mod.items["front_app"] then
		mod.items["front_app"]:set({ drawing = bool })
	end

	if config.window_manager == "yabai" then
		for i = 1, mod.space_count do
			sequencedAnimation(mod.items[i], "tanh", 30, nil, {
				width = bool and "dynamic" or 0,
				label = {
					width = (bool and mod.items[i].state.appc > 0 and not mod.items[i].state.selected) and "dynamic"
						or 0,
				},
			}, {
				drawing = bool,
			}, true)
		end
	else
		for _, item in pairs(mod.items) do
			if type(item) == "table" and item.state then
				sequencedAnimation(item, "tanh", 30, nil, {
					width = bool and "dynamic" or 0,
					label = { width = (bool and item.state.appc > 0 and not item.state.selected) and "dynamic" or 0 },
				}, {
					drawing = bool,
				}, true)
			end
		end
	end
	perfec()
end

-- ─── Yabai ───────────────────────────────────────────────────────────────────

local function yabaiWindowChange(item, space_index)
	return function(env)
		if not (env.INFO.space == space_index) then
			return
		end

		local c = 0
		local icon_strip = ""

		for k, v in pairs(env.INFO.apps) do
			icon_strip = icon_strip .. to_formatted_icon(k, v) .. " "
			c = c + 1
		end

		icon_strip = icon_strip:match("^(.-)%s*$")

		mergeTables(item.state, {
			apps = copyTable(env.INFO.apps),
			appc = c,
		}, false)

		if c > 0 then
			sequencedAnimation(item, "tanh", 15, {
				label = { string = icon_strip },
			}, {
				label = { width = "dynamic" },
			}, nil, true)

			if not item.state.selected then
				sbar.trigger("space_change")
			end
		else
			sequencedAnimation(item, "tanh", 15, {
				label = { string = "" },
			}, {
				label = { width = 0 },
			}, nil, true)

			sbar.trigger("space_change")
		end
	end
end

local function yabaiSpaceChange(item)
	return function(env)
		item.state.selected = (env.SELECTED ~= "false")

		local show
		local properties = { background = {} }

		if not item.state.selected and item.state.appc >= 1 then
			properties.background.drawing = true
			show = true
		else
			properties.background.drawing = false
			show = false
		end

		sequencedAnimation(item, "tanh", 15, properties, {
			icon = { highlight = env.SELECTED },
			label = { width = show and "dynamic" or 0 },
		}, nil, true)
	end
end

local function yabaiClick()
	return function(env)
		sbar.exec("yabai -m space --focus " .. env.SID)
	end
end

local function yabaiMouseHover(item)
	return function(env)
		if item.state.appc > 0 and item.state.selected == false then
			sbar.exec(execs.ft_haptic)
		end
	end
end

local function loadYabaiSpaces(zones)
	for i = 1, mod.space_count do
		local item = sbar.add(
			"space",
			mergeTables(mod.properties.space, {
				associated_space = i,
				icon = { string = i },
			})
		)

		item.state = { apps = {}, appc = 0, selected = false }

		mod.items[i] = item
		zones.brackets.spaces[i] = item

		item:subscribe("space_change", yabaiSpaceChange(item))
		item:subscribe("space_windows_change", yabaiWindowChange(item, i))
		item:subscribe("mouse.clicked", yabaiClick())
		item:subscribe("mouse.entered", yabaiMouseHover(item))
	end

	mod.items["separator"] = sbar.add("item", mod.properties.separator)
	mod.items["front_app"] = sbar.add("item", mod.properties.front_app)

	mod.items["front_app"]:subscribe("front_app_switched", function(env)
		local icon = app_icons[env.INFO] or app_icons["default"]
		mod.items["front_app"]:set({
			icon = { string = icon },
			label = { string = env.INFO },
		})
	end)
end

-- ─── Aerospace ───────────────────────────────────────────────────────────────

local function buildIconStrip(app_list)
	local strip = ""
	local c = 0
	for _, app in ipairs(app_list) do
		if app ~= "" then
			strip = strip .. (app_icons[app] or app_icons["default"]) .. " "
			c = c + 1
		end
	end
	return strip:match("^(.-)%s*$"), c
end

local function aerospaceWorkspaceChange(item, space_id)
	return function(env)
		local focused = shellEval("aerospace list-workspaces --focused 2>/dev/null")
		item.state.selected = (focused == space_id)

		local windows_raw = shellEval(
			string.format("aerospace list-windows --workspace %s --format '%%{app-name}' 2>/dev/null", space_id)
		)

		local app_list = (windows_raw ~= "") and strSplit(windows_raw, "\n") or {}
		local icon_strip, c = buildIconStrip(app_list)
		item.state.appc = c

		local show = not item.state.selected and c > 0

		sequencedAnimation(item, "tanh", 15, { label = { string = icon_strip } }, {
			icon = { highlight = item.state.selected },
			label = { width = show and "dynamic" or 0 },
		}, nil, true)
	end
end

local function aerospaceClick(space_id)
	return function(env)
		sbar.exec("aerospace workspace " .. space_id)
	end
end

local function aerospaceMouseHover(item)
	return function(env)
		if item.state.appc > 0 and not item.state.selected then
			sbar.exec(execs.ft_haptic)
		end
	end
end

local function loadAerospaceSpaces(zones)
	sbar.add("event", "aerospace_workspace_change")

	local workspaces_raw = shellEval("aerospace list-workspaces --all 2>/dev/null")
	local workspaces = strSplit(workspaces_raw, "\n")

	local idx = 1
	for _, space_id in ipairs(workspaces) do
		if space_id ~= "" then
			local item = sbar.add(
				"item",
				mergeTables(mod.properties.space, {
					icon = { string = space_id },
				})
			)

			item.state = { appc = 0, selected = false }

			mod.items[space_id] = item
			zones.brackets.spaces[idx] = item
			idx = idx + 1

			item:subscribe("aerospace_workspace_change", aerospaceWorkspaceChange(item, space_id))
			item:subscribe("mouse.clicked", aerospaceClick(space_id))
			item:subscribe("mouse.entered", aerospaceMouseHover(item))
		end
	end

	mod.items["separator"] = sbar.add("item", mod.properties.separator)
end

-- ─── Rift ────────────────────────────────────────────────────────────────────

local function riftWorkspaceChanged(item, space_name)
	return function(env)
		local focused =
			shellEval("rift-cli query workspaces 2>/dev/null | jq -r '.[] | select(.is_active == true) | .name'")
		item.state.selected = (focused == space_name)

		local escaped = space_name:gsub('"', '\\"')
		local windows_raw = shellEval(
			string.format(
				"rift-cli query workspaces 2>/dev/null | jq -r '.[] | select(.name == \"%s\") | .windows[].bundle_id'",
				escaped
			)
		)

		local bundle_list = (windows_raw ~= "") and strSplit(windows_raw, "\n") or {}
		local icon_strip, c = buildIconStrip(bundle_list)
		item.state.appc = c

		local show = not item.state.selected and c > 0

		sequencedAnimation(item, "tanh", 15, { label = { string = icon_strip } }, {
			icon = { highlight = item.state.selected },
			label = { width = show and "dynamic" or 0 },
		}, nil, true)
	end
end

local function riftClick(space_name)
	return function(env)
		local escaped = space_name:gsub('"', '\\"')
		sbar.exec(
			string.format(
				"rift-cli query workspaces | jq -r --arg name \"%s\" '.[] | select(.name == $name) | .index' | xargs -I{} rift-cli execute workspace switch {}",
				escaped
			)
		)
	end
end

local function riftMouseHover(item)
	return function(env)
		if item.state.appc > 0 and not item.state.selected then
			sbar.exec(execs.ft_haptic)
		end
	end
end

local function loadRiftSpaces(zones)
	sbar.add("event", "rift_workspace_changed")

	local workspaces_raw = shellEval("rift-cli query workspaces 2>/dev/null | jq -r '.[] | .name'")
	local workspaces = strSplit(workspaces_raw, "\n")

	local idx = 1
	for _, space_name in ipairs(workspaces) do
		if space_name ~= "" then
			local item_key = space_name:gsub(" ", "__")

			local item = sbar.add(
				"item",
				"space." .. item_key,
				mergeTables(mod.properties.space, {
					icon = { string = space_name },
				})
			)

			item.state = { appc = 0, selected = false }

			mod.items[item_key] = item
			zones.brackets.spaces[idx] = item
			idx = idx + 1

			item:subscribe("rift_workspace_changed", riftWorkspaceChanged(item, space_name))
			item:subscribe("mouse.clicked", riftClick(space_name))
			item:subscribe("mouse.entered", riftMouseHover(item))
		end
	end

	mod.items["separator"] = sbar.add("item", mod.properties.separator)
end

-- ─── Dispatch ────────────────────────────────────────────────────────────────

function mod.load(zones)
	if config.window_manager == "yabai" then
		loadYabaiSpaces(zones)
	elseif config.window_manager == "aerospace" then
		loadAerospaceSpaces(zones)
	elseif config.window_manager == "rift" then
		loadRiftSpaces(zones)
	end

	return mod
end

return mod
