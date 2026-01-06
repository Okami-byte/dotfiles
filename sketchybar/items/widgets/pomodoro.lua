local colors = require("colors")
local settings = require("settings")

-- Wi‑Fi-style pomodoro (stacked labels):
-- - Tomato emoji icon
-- - Top line: cycle + phase (e.g. "1/4 F", "1/4 SB", "4/4 LB")
-- - Bottom line: remaining time (MM:SS)
-- - No bracket/padding helper items
-- - 1s updates ONLY while running (paused = low-frequency idle tick)
-- - Cached rendering to avoid redundant set() calls

local durations = {
	focus = 25 * 60,
	short = 5 * 60,
	long = 15 * 60,
}
local cycle_total = 4

local phase = "focus"
local focus_completed = 0
local remaining = durations[phase]
local running = false
local last_tick = os.time()
local state_dir = os.getenv("HOME") .. "/.config/sketchybar/states"
local state_path = state_dir .. "/pomodoro_state.lua"
local last_saved_at = 0

-- Forward declaration: used by edit_durations() before assignment.
local update_display

-- Performance: only tick every second while running; otherwise stay mostly idle.
local RUN_TICK = 1
local IDLE_TICK = 300

local last_ui_top = nil
local last_ui_bottom = nil
local last_ui_top_color = nil
local last_ui_bottom_color = nil
local last_ui_freq = nil

-- Keep this tight to avoid large gaps to neighboring widgets.
local line_width = 44
local line_font = {
	family = settings.font.numbers,
	style = settings.font.style_map["Bold"],
	size = 9.0,
}

-- Add the stacked labels FIRST so the icon lands on the left on the right side.
-- Stack by making the "top" item width=0 so it overlays the "bottom" item.
local pomodoro_top = sbar.add("item", "pomodoro.top", {
	position = "right",
	width = 0,
	padding_left = 0,
	padding_right = 0,
	icon = { drawing = false },
	label = {
		font = line_font,
		width = line_width,
		padding_left = 2,
		padding_right = 4,
		align = "left",
		color = colors.red,
		string = "1/4 F",
	},
	y_offset = 5,
	background = { drawing = false },
})

local pomodoro_bottom = sbar.add("item", "pomodoro.bottom", {
	position = "right",
	padding_left = 0,
	padding_right = 0,
	icon = { drawing = false },
	label = {
		font = line_font,
		width = line_width,
		padding_left = 2,
		padding_right = 4,
		align = "left",
		color = colors.green,
		string = "25:00",
	},
	y_offset = -5,
	background = { drawing = false },
})

local pomodoro = sbar.add("item", "pomodoro", {
	position = "right",
	icon = {
		string = "􀐱 ",
		color = colors.red,
		font = {
			style = settings.font.style_map["Regular"],
			size = 15.0,
		},
		padding_right = settings.paddings,
		y_offset = 1,
	},
	label = { drawing = false },
	padding_left = 0,
	padding_right = 0,
	update_freq = IDLE_TICK,
	background = { drawing = false },
})

local function ensure_state_dir()
	os.execute('mkdir -p "' .. state_dir .. '"')
end

local function save_pomodoro_state()
	ensure_state_dir()
	local file = io.open(state_path, "w")
	if not file then
		return
	end

	local focus_minutes = math.max(1, math.floor(durations.focus / 60))
	local short_minutes = math.max(1, math.floor(durations.short / 60))
	local long_minutes = math.max(1, math.floor(durations.long / 60))

	local fc = math.floor(tonumber(focus_completed) or 0)
	local rem = math.floor(tonumber(remaining) or (durations[phase] or 0))
	if rem < 0 then
		rem = 0
	end

	local lines = {
		"return {",
		"  config = {",
		string.format("    focus = %d,", focus_minutes),
		string.format("    short = %d,", short_minutes),
		string.format("    long = %d,", long_minutes),
		"  },",
		"  state = {",
		string.format("    phase = %q,", tostring(phase)),
		string.format("    focus_completed = %d,", fc),
		string.format("    remaining = %d,", rem),
		string.format("    running = %s,", running and "true" or "false"),
		"  },",
		"}",
	}

	file:write(table.concat(lines, "\n"))
	file:write("\n")
	file:close()
end

local function save_state_throttled(force)
	local now = os.time()
	if force or (now - last_saved_at) >= 60 then
		save_pomodoro_state()
		last_saved_at = now
	end
end

local function load_pomodoro_state()
	local chunk = loadfile(state_path, "t", {})
	if not chunk then
		return
	end

	local ok, data = pcall(chunk)
	if not ok or type(data) ~= "table" then
		return
	end

	local config = type(data.config) == "table" and data.config or nil
	if config then
		local keys = { "focus", "short", "long" }
		for _, key in ipairs(keys) do
			local minutes = tonumber(config[key])
			if minutes and minutes > 0 then
				durations[key] = math.floor(minutes) * 60
			end
		end
	end

	local state = type(data.state) == "table" and data.state or nil
	if state then
		local loaded_phase = state.phase
		if type(loaded_phase) == "string" and durations[loaded_phase] then
			phase = loaded_phase
		end

		local loaded_focus = tonumber(state.focus_completed)
		if loaded_focus then
			focus_completed = math.floor(loaded_focus)
		end

		local loaded_remaining = tonumber(state.remaining)
		if loaded_remaining then
			remaining = math.min(math.max(math.floor(loaded_remaining), 0), durations[phase])
		else
			remaining = durations[phase]
		end

		running = state.running == true
	else
		remaining = durations[phase]
	end

	last_tick = os.time()
end

local function format_time(seconds)
	local safe_seconds = math.max(seconds, 0)
	local minutes = math.floor(safe_seconds / 60)
	local secs = safe_seconds % 60
	return string.format("%02d:%02d", minutes, secs)
end

local function progress_text()
	if phase == "focus" then
		local current = (focus_completed % cycle_total) + 1
		return string.format("%d/%d", current, cycle_total)
	end

	local completed = focus_completed % cycle_total
	if completed == 0 then
		completed = cycle_total
	end
	return string.format("%d/%d", completed, cycle_total)
end

local function phase_color()
	if phase == "focus" then
		return colors.red
	end
	if phase == "short" then
		return colors.green
	end
	return colors.blue
end

local function phase_label(target)
	if target == "focus" then
		return "Focus"
	end
	if target == "short" then
		return "Short break"
	end
	return "Long break"
end

local function escape_applescript_string(s)
	s = tostring(s or "")
	-- Escape for "..." in osascript -e '...'.
	return s:gsub("\\", "\\\\"):gsub('"', '\\"')
end

local function notify(message)
	local safe = escape_applescript_string(message)
	local cmd =
		string.format([[osascript -e 'display notification "%s" with title "Pomodoro" sound name "Glass"']], safe)
	sbar.exec(cmd)
end

local function edit_durations()
	local focus_minutes = math.floor(durations.focus / 60)
	local short_minutes = math.floor(durations.short / 60)
	local long_minutes = math.floor(durations.long / 60)
	local script = string.format(
		[[osascript -e 'set focusMinutes to text returned of (display dialog "Focus minutes" default answer "%d")' -e 'set shortMinutes to text returned of (display dialog "Short break minutes" default answer "%d")' -e 'set longMinutes to text returned of (display dialog "Long break minutes" default answer "%d")' -e 'return focusMinutes & "," & shortMinutes & "," & longMinutes']],
		focus_minutes,
		short_minutes,
		long_minutes
	)

	sbar.exec(script, function(result, exit_code)
		if exit_code ~= 0 then
			return
		end
		if type(result) ~= "string" then
			return
		end

		local focus_str, short_str, long_str = result:match("^(%d+),(%d+),(%d+)%s*$")
		if not focus_str then
			return
		end

		local focus_value = tonumber(focus_str)
		local short_value = tonumber(short_str)
		local long_value = tonumber(long_str)
		if not focus_value or focus_value < 1 then
			return
		end
		if not short_value or short_value < 1 then
			return
		end
		if not long_value or long_value < 1 then
			return
		end

		durations.focus = focus_value * 60
		durations.short = short_value * 60
		durations.long = long_value * 60
		remaining = durations[phase]
		last_tick = os.time()
		update_display()
		save_state_throttled(true)
	end)
end

update_display = function()
	local phase_tag = "F"
	if phase == "short" then
		phase_tag = "S"
	end
	if phase == "long" then
		phase_tag = "L"
	end

	local top = string.format("%s %s", progress_text(), phase_tag)

	local bottom = format_time(remaining)
	local freq = running and RUN_TICK or IDLE_TICK
	local top_color = running and colors.green or colors.white
	local bottom_color = running and colors.green or colors.white

	local props = nil

	if last_ui_freq ~= freq then
		props = props or {}
		props.update_freq = freq
		last_ui_freq = freq
	end

	if props then
		pomodoro:set(props)
	end

	if last_ui_top ~= top or last_ui_top_color ~= top_color then
		local label = {}
		if last_ui_top ~= top then
			label.string = top
		end
		if last_ui_top_color ~= top_color then
			label.color = top_color
		end
		pomodoro_top:set({ label = label })
		last_ui_top = top
		last_ui_top_color = top_color
	end

	if last_ui_bottom ~= bottom or last_ui_bottom_color ~= bottom_color then
		local label = {}
		if last_ui_bottom ~= bottom then
			label.string = bottom
		end
		if last_ui_bottom_color ~= bottom_color then
			label.color = bottom_color
		end
		pomodoro_bottom:set({ label = label })
		last_ui_bottom = bottom
		last_ui_bottom_color = bottom_color
	end

	if running then
		save_state_throttled(false)
	end
end

local function start_phase(next_phase)
	phase = next_phase
	remaining = durations[phase]
	last_tick = os.time()
	running = true

	update_display()
	save_state_throttled(true)
end

local function advance_phase()
	local previous_phase = phase
	local next_phase = "focus"
	if phase == "focus" then
		focus_completed = focus_completed + 1
		if focus_completed % cycle_total == 0 then
			next_phase = "long"
		else
			next_phase = "short"
		end
	end
	notify(string.format("%s ended, %s started", phase_label(previous_phase), phase_label(next_phase)))
	start_phase(next_phase)
end

local function toggle_running()
	running = not running
	if running then
		last_tick = os.time()
	end
	update_display()
	save_state_throttled(true)
end

local function reset_phase()
	remaining = durations[phase]
	last_tick = os.time()
	update_display()
	save_state_throttled(true)
end

local function pomodoro_on_click(env)
	if env.BUTTON == "middle" or env.BUTTON == "other" then
		edit_durations()
		return
	end
	if env.BUTTON == "right" then
		reset_phase()
		return
	end
	if env.BUTTON ~= "left" then
		return
	end
	toggle_running()
end

pomodoro:subscribe("mouse.clicked", pomodoro_on_click)
pomodoro_top:subscribe("mouse.clicked", pomodoro_on_click)
pomodoro_bottom:subscribe("mouse.clicked", pomodoro_on_click)

pomodoro:subscribe("routine", function()
	if _G.SKETCHYBAR_SUSPENDED then
		return
	end
	if running then
		local now = os.time()
		local elapsed = now - last_tick
		if elapsed > 0 then
			remaining = remaining - elapsed
			last_tick = now
		end
		if remaining <= 0 then
			advance_phase()
			return
		end
	end
	update_display()
end)

load_pomodoro_state()
update_display()

pomodoro:subscribe("system_woke", function(_)
	if _G.SKETCHYBAR_SUSPENDED then
		return
	end
	if running then
		local now = os.time()
		local elapsed = now - last_tick
		if elapsed > 0 then
			remaining = remaining - elapsed
			last_tick = now
		end
		if remaining <= 0 then
			advance_phase()
			return
		end
	end
	update_display()
end)
