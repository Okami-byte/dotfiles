--[[
  Space indicators — icon-only variant
  =====================================
  One item per virtual desktop ("space" / "workspace"), each showing a
  static SF Symbol glyph (see SPACE_ICONS below) plus a trailing separator
  and, on yabai, a "front app" badge. Selected by the require in
  items/init.lua:48 — point that line at items/spaces.lua instead for the
  variant that shows the running apps' own icons.

  Layout of this file, top to bottom:
    1. SPACE_ICONS     the glyph shown on each space — this is almost
                       certainly the only part you need to edit.
    2. mod.setup()     static appearance (padding, colors, sizes).
    3. mod.show()      the animation that reveals/hides the group.
    4. Shared helpers  wiring reused by two or more backends below.
    5. One section per supported window manager (Yabai / AeroSpace / Rift).
       Only one runs, picked by config.window_manager.
    6. mod.load()      dispatches to the section above.

  Adding a new window manager: copy the AeroSpace section (the simplest
  template) and rename its functions. Keep its three calls into the shared
  state every backend must set up for every item it creates —
  newSpaceState() for item.state (mod.show() filters on it),
  registerSpaceItem() for mod.items and zones.brackets.spaces (zones.lua
  draws the zone border from it), and addSeparator() for
  mod.items["separator"] (mod.show() refuses to run without it) —
  then add an entry to WINDOW_MANAGER_LOADERS near the bottom of this file.
]]

local mod = {}
local app_icons = require("helpers.app_icons")

-- Per-space symbol glyphs. The key means something different per backend
-- below: for yabai it's the actual macOS space index (spaces without an
-- entry fall back to their plain number, and mod.space_count = 15 spaces
-- always exist); for AeroSpace/Rift it's just the workspace's position in
-- the CLI's listing order, unrelated to that workspace's own name/number.
-- Drop SF Symbols PUA glyphs from the SF Symbols Beta app here.
local SPACE_ICONS = {
	[1] = "􀪏", -- terminal
	[2] = "􀆪", -- browser (Safari / globe)
	[3] = "􀣫", -- mail
	[4] = "􀷾", -- to-do list
	[5] = "􀬗", -- misc (robot)
}

local function spaceIcon(idx)
	local icon = SPACE_ICONS[idx]
	return (icon ~= nil and icon ~= "") and icon or tostring(idx)
end

-- Setup
function mod.setup(bar, zones, palette)
	mod.properties = {
		-- The per-space item itself (icon only, no label).
		space = {
			padding_left = 2,
			padding_right = 2,

			icon = {
				padding_left = 6,
				padding_right = 7,
				color = palette.text.muted,
				highlight_color = palette.colors.orange,
			},

			background = {
				height = bar.config.height - 12,
				corner_radius = zones.properties.background.corner_radius - 1,
				color = palette.zone.border,
				drawing = false,
			},

			label = { drawing = false },
		},
		-- Trailing "+" separator, click yabai to create a new space.
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
		-- Yabai only: shows the focused app's icon + name next to the spaces.
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
				color = palette.colors.cyan,
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

	mod.space_count = 15 -- yabai only: fixed number of spaces to create
	mod.items = {}
	return mod
end

-- Show / hide all space items
function mod.show(bool)
	if mod.items["separator"] == nil then
		log("spaces_icons", "mod.show() called with no separator registered, ignoring")
		return
	end

	perfbc()
	mod.items["separator"]:set({ drawing = bool })

	if mod.items["front_app"] then
		mod.items["front_app"]:set({ drawing = bool })
	end

	if config.window_manager == "yabai" then
		for i = 1, mod.space_count do
			sequencedAnimation(mod.items[i], "tanh", 30, bool and { drawing = true } or nil, {
				width = bool and "dynamic" or 0,
			}, {
				drawing = bool,
			}, true)
		end
	else
		for _, item in pairs(mod.items) do
			if type(item) == "table" and item.state then
				sequencedAnimation(item, "tanh", 30, nil, {
					width = bool and "dynamic" or 0,
				}, not bool and { drawing = false } or nil, true)
			end
		end
	end
	perfec()
end

-- ─── Shared helpers ──────────────────────────────────────────────────────────
-- Per-item wiring and polling logic reused by two or more backends below,
-- pulled out so each backend section only shows what's actually specific
-- to it.

-- Counts the non-empty entries of a list, e.g. app names returned by a CLI.
-- (strSplit already drops empty entries; this is defensive.)
local function countNonEmpty(list)
	local c = 0
	for _, v in ipairs(list) do
		if v ~= "" then
			c = c + 1
		end
	end
	return c
end

-- Base per-space state every backend tracks. Pass `apps` only for yabai,
-- which keeps a live app map around (see yabaiWindowChange below); other
-- backends leave it nil and only ever look at appc/selected.
local function newSpaceState(apps)
	return { apps = apps, appc = 0, selected = false }
end

-- Registers a space item under both lookup tables every backend needs:
-- mod.items (keyed by whatever identifies the space to that backend) and
-- zones.brackets.spaces (keyed by on-screen position, for the zone border).
local function registerSpaceItem(zones, key, position, item)
	mod.items[key] = item
	zones.brackets.spaces[position] = item
end

-- Adds the trailing separator item shared by every backend. Pass a handler
-- to make it clickable (yabai uses this to create a new space).
local function addSeparator(on_click)
	local separator = sbar.add("item", mod.properties.separator)
	if on_click then
		separator:subscribe("mouse.clicked", on_click)
	end
	mod.items["separator"] = separator
end

-- Nudges the trackpad when hovering an occupied, unselected space.
local function mouseHoverHaptic(item)
	return function(_)
		if item.state.appc > 0 and not item.state.selected then
			sbar.exec(execs.ft_haptic)
		end
	end
end

-- Polls "which workspace is focused" and "which windows live in this one"
-- shell commands, records the result, and animates the icon highlight.
-- Shared by every backend that discovers workspace state by polling a CLI
-- on a "workspace changed" event (AeroSpace, Rift) rather than yabai's
-- event payload.
local function pollAndApplyWorkspaceState(item, workspace_id, focused_cmd, windows_cmd)
	local focused = shellEval(focused_cmd)

	local windows_raw = shellEval(windows_cmd)
	local windows = (windows_raw ~= "") and strSplit(windows_raw, "\n") or {}

	item.state.selected = (focused == workspace_id)
	item.state.appc = countNonEmpty(windows)

	sequencedAnimation(item, "tanh", 15, nil, {
		icon = { highlight = item.state.selected },
	}, nil, true)
end

-- ─── Yabai ───────────────────────────────────────────────────────────────────
-- Fixed set of mod.space_count spaces; occupancy comes from yabai's
-- "space_windows_change" event instead of polling.

local function yabaiWindowChange(item, space_index)
	return function(env)
		if not (env.INFO.space == space_index) then
			return
		end

		local c = 0
		for _ in pairs(env.INFO.apps) do
			c = c + 1
		end

		mergeTables(item.state, {
			apps = copyTable(env.INFO.apps),
			appc = c,
		}, false)

		sbar.trigger("space_change")
	end
end

local function yabaiSpaceChange(item)
	return function(env)
		item.state.selected = (env.SELECTED ~= "false")

		sequencedAnimation(item, "tanh", 15, {
			background = { drawing = not item.state.selected and item.state.appc >= 1 },
		}, {
			icon = { highlight = env.SELECTED },
		}, nil, true)
	end
end

local function yabaiClick(item)
	return function(env)
		local op = (env.BUTTON == "right") and "--destroy" or "--focus"
		sbar.exec("yabai -m space " .. op .. " " .. env.SID)
	end
end

local function loadYabaiSpaces(zones)
	for i = 1, mod.space_count do
		local item = sbar.add(
			"space",
			mergeTables(mod.properties.space, {
				associated_space = i,
				icon = { string = spaceIcon(i) },
			})
		)

		item.state = newSpaceState({})
		registerSpaceItem(zones, i, i, item)

		item:subscribe("space_change", yabaiSpaceChange(item))
		item:subscribe("space_windows_change", yabaiWindowChange(item, i))
		item:subscribe("mouse.clicked", yabaiClick(item))
		item:subscribe("mouse.entered", mouseHoverHaptic(item))
	end

	addSeparator(function(_)
		sbar.exec("yabai -m space --create")
	end)

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
-- Workspaces are discovered once at load time via the `aerospace` CLI, then
-- refreshed on the "aerospace_workspace_change" event (polls the CLI again).

local function aerospaceWorkspaceChange(item, space_id)
	return function(_)
		pollAndApplyWorkspaceState(
			item,
			space_id,
			"aerospace list-workspaces --focused 2>/dev/null",
			string.format("aerospace list-windows --workspace %s --format '%%{app-name}' 2>/dev/null", space_id)
		)
	end
end

local function aerospaceClick(space_id)
	return function(_)
		sbar.exec("aerospace workspace " .. space_id)
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
					icon = { string = spaceIcon(idx) },
				})
			)

			item.state = newSpaceState()
			registerSpaceItem(zones, space_id, idx, item)
			idx = idx + 1

			item:subscribe("aerospace_workspace_change", aerospaceWorkspaceChange(item, space_id))
			item:subscribe("mouse.clicked", aerospaceClick(space_id))
			item:subscribe("mouse.entered", mouseHoverHaptic(item))
		end
	end

	addSeparator()
end

-- ─── Rift ────────────────────────────────────────────────────────────────────
-- Same polling shape as AeroSpace above, but sourced from `rift-cli query
-- workspaces` (JSON, parsed with jq) instead of AeroSpace's plain-text CLI.

local function riftWorkspaceChanged(item, space_name)
	return function(_)
		local escaped = space_name:gsub('"', '\\"')

		pollAndApplyWorkspaceState(
			item,
			space_name,
			"rift-cli query workspaces 2>/dev/null | jq -r '.[] | select(.is_active == true) | .name'",
			string.format(
				"rift-cli query workspaces 2>/dev/null | jq -r '.[] | select(.name == \"%s\") | .windows[].bundle_id'",
				escaped
			)
		)
	end
end

local function riftClick(space_name)
	return function(_)
		local escaped = space_name:gsub('"', '\\"')
		sbar.exec(
			string.format(
				"rift-cli query workspaces | jq -r --arg name \"%s\" '.[] | select(.name == $name) | .index' | xargs -I{} rift-cli execute workspace switch {}",
				escaped
			)
		)
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
					icon = { string = spaceIcon(idx) },
				})
			)

			item.state = newSpaceState()
			registerSpaceItem(zones, item_key, idx, item)
			idx = idx + 1

			item:subscribe("rift_workspace_changed", riftWorkspaceChanged(item, space_name))
			item:subscribe("mouse.clicked", riftClick(space_name))
			item:subscribe("mouse.entered", mouseHoverHaptic(item))
		end
	end

	addSeparator()
end

-- ─── Dispatch ────────────────────────────────────────────────────────────────
-- config.window_manager (see config.lua) selects exactly one loader below.
-- To support another window manager, add it here after writing its section.

local WINDOW_MANAGER_LOADERS = {
	yabai = loadYabaiSpaces,
	aerospace = loadAerospaceSpaces,
	rift = loadRiftSpaces,
}

function mod.load(zones)
	local loader = WINDOW_MANAGER_LOADERS[config.window_manager]

	if loader then
		loader(zones)
	else
		log("spaces_icons", "unknown config.window_manager '" .. tostring(config.window_manager) .. "', no space items created")
	end

	return mod
end

return mod
