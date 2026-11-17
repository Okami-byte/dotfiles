-- Coding-agent status from herdr.
--
-- Bar: the most urgent status across all agents (blocked > working > done >
-- idle > unknown) with how many agents are in it. Driven by
-- helpers/agent_watch.py, which listens on herdr's socket and fires
-- "agents_update" only when something changes (no polling).
--
-- Click: popup listing every agent (status, title, folder). Clicking a row
-- focuses that agent in herdr and brings the terminal forward.

local popup = require("helpers/popup")

local mod = {}

local popup_width = 300
local max_rows = 8
local pane_ids = {} -- row index -> herdr pane id, for click-to-focus

-- Setup
function mod.setup(icons, palette)
	mod.status = {
		blocked = { icon = icons.agents.blocked, color = palette.colors.red },
		working = { icon = icons.agents.working, color = palette.colors.yellow },
		done = { icon = icons.agents.done, color = palette.colors.cyan },
		idle = { icon = icons.agents.idle, color = palette.colors.blue },
		unknown = { icon = icons.agents.unknown, color = palette.text.subtle },
		none = { icon = icons.agents.none, color = palette.text.muted },
	}

	mod.properties = {
		updates = true, -- keep tracking status while the zone is collapsed
		position = "right",
		icon = {
			font = { family = icons.agents.font, style = "Regular", size = 16.0 },
			string = mod.status.none.icon,
			color = mod.status.none.color,
		},
		label = { drawing = false },
		popup = { align = "center" },
	}
	mod.event = "agents_update"

	return mod
end

local function startWatcher(event_name)
	sbar.exec(
		[[
    #SKETCHYBAR_AGENT_WATCH#
    lastpid=$(cat ${TMPDIR}/sketchybar/agent_pids 2> /dev/null || echo 0)
    if ps -p $lastpid -o command= | grep 'agent_watch.py' > /dev/null; then
      kill $lastpid
    fi
    mkdir -p ${TMPDIR}/sketchybar
    ./helpers/agent_watch.py ]] .. event_name .. [[ "$(command -v sketchybar)" > /dev/null 2>&1 &
    echo $! > ${TMPDIR}/sketchybar/agent_pids
  ]],
		function() end
	)
end

local function setBar(status, count)
	local s = mod.status[status] or mod.status.unknown
	mod.item:set({
		icon = { string = s.icon, color = s.color },
		label = { drawing = count > 0, string = tostring(count) },
	})
end

local function addRows(icons, palette)
	mod.rows = {}
	for i = 1, max_rows do
		local row = sbar.add("item", {
			position = "popup." .. mod.item.name,
			drawing = false,
			icon = {
				font = { family = icons.agents.font, style = "Regular", size = 14.0 },
				width = 26,
			},
			label = { width = popup_width - 26, max_chars = 40 },
			background = { color = 0x00000000 },
		})
		row:subscribe("mouse.clicked", function()
			if pane_ids[i] then
				sbar.exec(execs.herdr .. " agent focus '" .. pane_ids[i] .. "' && open -a " .. config.agent_terminal)
			end
			popup.hide(mod.item)
		end)
		mod.rows[i] = row
	end

	mod.empty_row = sbar.add("item", {
		position = "popup." .. mod.item.name,
		drawing = false,
		icon = { drawing = false },
		label = { string = "No agents running", color = palette.text.muted, width = popup_width },
		background = { color = 0x00000000 },
	})
end

local function basename(path)
	return (path or ""):match("([^/]+)/?$") or ""
end

local function fillRows()
	sbar.exec(execs.herdr .. " agent list", function(result)
		local agents = type(result) == "table" and result.result and result.result.agents or {}
		mod.empty_row:set({ drawing = #agents == 0 })

		for i, row in ipairs(mod.rows) do
			local a = agents[i]
			if a then
				local s = mod.status[a.agent_status] or mod.status.unknown
				local label = (a.terminal_title_stripped or a.agent or "agent") .. "  ·  " .. basename(a.cwd)
				pane_ids[i] = a.pane_id
				if i == max_rows and #agents > max_rows then
					label = string.format("+%d more…", #agents - max_rows + 1)
					pane_ids[i] = nil
				end
				row:set({
					drawing = true,
					icon = { string = s.icon, color = s.color },
					label = { string = label },
				})
			else
				pane_ids[i] = nil
				row:set({ drawing = false })
			end
		end
	end)
end

-- Load
function mod.load(icons, palette)
	if not execs.herdr then
		return mod
	end

	sbar.add("event", mod.event)
	mod.item = sbar.add("item", mod.properties)
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
	addRows(icons, palette)

	mod.item:subscribe(mod.event, function(env)
		setBar(env.STATUS, tonumber(env.COUNT) or 0)
		if mod.item:query().popup.drawing == "on" then
			fillRows()
		end
	end)
	mod.item:subscribe("mouse.clicked", function()
		popup.toggle(mod.item, fillRows)
	end)
	popup.auto_hide(mod.item)

	startWatcher(mod.event)
	return mod
end

return mod
