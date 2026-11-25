-- Coding-agent status from herdr or tmux (pick with config.agent_mux).
--
-- Bar: the most urgent status across all agents (blocked > working > done >
-- idle > unknown) with how many agents are in it. Driven by a watcher that
-- fires "agents_update" only when something changes:
--   herdr: helpers/agent_watch.py listens on herdr's socket (no polling).
--   tmux:  helpers/agent_watch_tmux.py reads the @agent_status pane option
--          that helpers/tmux_agent_hook.sh sets from Claude Code hooks.
--
-- Click: popup listing every agent (status, title, folder/session). Clicking
-- a row focuses that agent and brings the terminal forward.

local popup = require("helpers/popup")

local mod = {}

local popup_width = 300
local max_rows = 8
local pane_ids = {} -- row index -> pane id, for click-to-focus
local sessions = {} -- row index -> tmux session name (tmux backend only)

local function basename(path)
	return (path or ""):match("([^/]+)/?$") or ""
end

-- Backends -------------------------------------------------------------------
-- Each one: available(), watcher (script + args), list_cmd, row_label(agent),
-- focus(row index).

local backends = {}

backends.herdr = {
	available = function()
		return execs.herdr ~= nil
	end,
	watcher = "agent_watch.py",
	watcher_args = function(event_name)
		return event_name .. ' "$(command -v sketchybar)"'
	end,
	list_cmd = function()
		return execs.herdr .. " agent list"
	end,
	agents = function(result)
		return type(result) == "table" and result.result and result.result.agents or {}
	end,
	row_label = function(a)
		return (a.terminal_title_stripped or a.agent or "agent") .. "  ·  " .. basename(a.cwd)
	end,
	focus = function(i)
		sbar.exec(execs.herdr .. " agent focus '" .. pane_ids[i] .. "' && open -a " .. config.agent_terminal)
	end,
}

backends.tmux = {
	available = function()
		return execs.tmux ~= nil
	end,
	watcher = "agent_watch_tmux.py",
	watcher_args = function(event_name)
		return event_name .. ' "$(command -v sketchybar)" ' .. execs.tmux
	end,
	list_cmd = function()
		return "./helpers/agent_watch_tmux.py --list " .. execs.tmux
	end,
	agents = function(result)
		return type(result) == "table" and result.agents or {}
	end,
	row_label = function(a)
		local title = (a.title ~= "" and a.title) or a.agent or "agent"
		return title .. "  ·  " .. (a.session or basename(a.cwd))
	end,
	-- Switch the most recently used tmux client to the agent's pane. With no
	-- client attached, open a terminal and let sesh attach the session.
	focus = function(i)
		local t, pane = execs.tmux, pane_ids[i]
		local sesh = execs.sesh and string.format(
			"open -na %s --args %s connect '%s'",
			config.agent_terminal,
			execs.sesh,
			sessions[i]
		) or ("open -a " .. config.agent_terminal)
		sbar.exec(string.format(
			"if [ -n \"$(%s list-clients 2>/dev/null)\" ]; then "
				.. "%s switch-client -t '%s' \\; select-window -t '%s' \\; select-pane -t '%s' && open -a %s; "
				.. "else %s; fi",
			t, t, pane, pane, pane, config.agent_terminal, sesh
		))
	end,
}

-- Setup ----------------------------------------------------------------------
function mod.setup(icons, palette)
	mod.backend = backends[config.agent_mux] or backends.tmux

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
			font = { family = icons.nerd_font, style = "Regular", size = 16.0 },
			string = mod.status.none.icon,
			color = mod.status.none.color,
		},
		label = { drawing = false },
		popup = { align = "center" },
	}
	mod.event = "agents_update"

	return mod
end

-- Starts the backend's watcher, killing whichever one (herdr or tmux) ran last.
local function startWatcher(event_name)
	local b = mod.backend
	sbar.exec(
		[[
    #SKETCHYBAR_AGENT_WATCH#
    lastpid=$(cat ${TMPDIR}/sketchybar/agent_pids 2> /dev/null || echo 0)
    if ps -p $lastpid -o command= | grep -E 'agent_watch(_tmux)?\.py' > /dev/null; then
      kill $lastpid
    fi
    mkdir -p ${TMPDIR}/sketchybar
    ./helpers/]] .. b.watcher .. " " .. b.watcher_args(event_name) .. [[ > /dev/null 2>&1 &
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
				font = { family = icons.nerd_font, style = "Regular", size = 14.0 },
				width = 26,
			},
			label = { width = popup_width - 26, max_chars = 40 },
			background = { color = 0x00000000 },
		})
		row:subscribe("mouse.clicked", function()
			if pane_ids[i] then
				mod.backend.focus(i)
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

local function fillRows()
	local b = mod.backend
	sbar.exec(b.list_cmd(), function(result)
		local agents = b.agents(result)
		mod.empty_row:set({ drawing = #agents == 0 })

		for i, row in ipairs(mod.rows) do
			local a = agents[i]
			if a then
				local s = mod.status[a.agent_status] or mod.status.unknown
				local label = b.row_label(a)
				pane_ids[i], sessions[i] = a.pane_id, a.session
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
				pane_ids[i], sessions[i] = nil, nil
				row:set({ drawing = false })
			end
		end
	end)
end

-- Load -----------------------------------------------------------------------
function mod.load(icons, palette)
	if not mod.backend.available() then
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
