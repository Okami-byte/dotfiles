local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local popup = require("helpers.popup")

local popup_width = 250

local function trim_newline(s)
	return (s or ""):gsub("\r", ""):gsub("\n$", "")
end

local function exec(cmd, cb)
	sbar.exec(cmd, cb)
end

-- no manual multi-line splitting needed now

local function build_jxa_cmd(js_lines, argv)
	local parts = {}
	for _, line in ipairs(js_lines) do
		parts[#parts + 1] = "-e " .. string.format("%q", line)
	end
	local cmd = "/usr/bin/osascript -l JavaScript " .. table.concat(parts, " ")
	if argv then
		cmd = cmd .. " -- " .. string.format("%q", argv)
	end
	return cmd
end

local function jxa_admin_cmd(shell_cmd)
	local js_lines = {
		"function run(argv) {",
		"  var cmd = argv[0];",
		"  var app = Application.currentApplication();",
		"  app.includeStandardAdditions = true;",
		"  try { return app.doShellScript(cmd, {administratorPrivileges: true}); } catch (e) { return String(e); }",
		"}",
	}
	return build_jxa_cmd(js_lines, shell_cmd)
end

-- Time Machine widget
local tm = sbar.add("item", "widgets.time_machine", {
	position = "right",
	icon = {
		string = icons.time_machine,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Regular"],
			size = 16.0,
		},
		color = colors.white,
	},
	label = { drawing = false },
	background = { drawing = false },
	padding_left = settings.paddings,
	padding_right = settings.paddings,
	updates = true,
})

-- Create bracket for popup attachment
local tm_bracket = sbar.add("bracket", "widgets.time_machine.bracket", {
	tm.name,
}, {
	background = { drawing = false },
	popup = { align = "center" },
})

popup.register(tm_bracket)

tm:subscribe("mouse.entered", function(_)
	tm:set({ icon = { color = colors.foam } })
end)

tm:subscribe("mouse.exited", function(_)
	tm:set({ icon = { color = colors.white } })
end)

-- Popup items
-- Title row
local title_item = sbar.add("item", {
	position = "popup." .. tm_bracket.name,
	icon = {
		font = { style = settings.font.style_map["Bold"] },
		string = icons.time_machine,
	},
	width = popup_width,
	align = "center",
	label = {
		font = { size = 15, style = settings.font.style_map["Bold"] },
		string = "Time Machine",
	},
	background = { height = 2, color = colors.grey, y_offset = -15 },
})

-- Status row under title
local status_row = sbar.add("item", {
	position = "popup." .. tm_bracket.name,
	width = popup_width,
	icon = { align = "left", string = "Status:", width = popup_width / 2 },
	label = { align = "right", string = "—", width = popup_width / 2 },
})

-- Latest single row
local latest_row = sbar.add("item", {
	position = "popup." .. tm_bracket.name,
	width = popup_width,
	icon = { align = "left", string = "Latest:", width = popup_width / 2 },
	label = { align = "right", string = "—", width = popup_width / 2 },
})

-- Actions stacked under latest
local action_start = sbar.add("item", {
	position = "popup." .. tm_bracket.name,
	width = popup_width,
	icon = { align = "left", string = "Start backup", width = popup_width },
	label = { drawing = false },
})
local action_stop = sbar.add("item", {
	position = "popup." .. tm_bracket.name,
	width = popup_width,
	icon = { align = "left", string = "Stop backup", width = popup_width },
	label = { drawing = false },
})
local action_open_dest = sbar.add("item", {
	position = "popup." .. tm_bracket.name,
	width = popup_width,
	icon = { align = "left", string = "Open destination", width = popup_width },
	label = { drawing = false },
})
local action_open_tm = sbar.add("item", {
	position = "popup." .. tm_bracket.name,
	width = popup_width,
	icon = { align = "left", string = "Open Time Machine", width = popup_width },
	label = { drawing = false },
})

local function populate_tm_details()
	-- Update status
	local status_cmd = [[/bin/zsh -lc '
    out=$(tmutil status 2>/dev/null || true)
    if printf "%s" "$out" | grep -q "Running = 1"; then
      echo Running
    else
      echo Idle
    fi
  ']]
	exec(status_cmd, function(out)
		local status = trim_newline(out)
		if status == "" then
			status = "—"
		end
		status_row:set({ label = { string = status } })
	end)

	-- Latest backup only (use tmutil latestbackup)
	local latest_cmd = [[/bin/zsh -lc '
    out=$(tmutil latestbackup 2>&1); code=$?
    if [ $code -ne 0 ] || printf "%s" "$out" | grep -qiE "not permitted|not authorized"; then
      echo "Full Disk Access required"
    else
      ts=$(printf "%s\n" "$out" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}" | tail -n1)
      if [ -n "$ts" ]; then
        date_part=$(printf "%s" "$ts" | cut -c1-10)
        h=$(printf "%s" "$ts" | cut -c12-13)
        m=$(printf "%s" "$ts" | cut -c14-15)
        printf "%s %s:%s\n" "$date_part" "$h" "$m"
      else
        echo "No backups found"
      fi
    fi
  ']]
	exec(latest_cmd, function(result)
		local text = trim_newline(result)
		if text == "" then
			text = "—"
		end
		latest_row:set({ label = { string = text } })
	end)
end

-- Click handlers for actions (stacked)
action_start:subscribe("mouse.clicked", function(_)
	exec(jxa_admin_cmd("tmutil startbackup"), function(_)
		sbar.delay(0.5, function()
			populate_tm_details()
		end)
	end)
end)

action_stop:subscribe("mouse.clicked", function(_)
	exec(jxa_admin_cmd("tmutil stopbackup"), function(_)
		sbar.delay(0.5, function()
			populate_tm_details()
		end)
	end)
end)

action_open_dest:subscribe("mouse.clicked", function(_)
	local cmd =
		[[/bin/zsh -lc 'tmutil destinationinfo 2>/dev/null | grep "^URL" | head -n1 | cut -d: -f2- | sed -E "s/^ +//; s/ +$//"']]
	exec(cmd, function(url)
		url = (url or ""):gsub("\n$", "")
		if url ~= "" then
			exec("/bin/zsh -lc 'open \"" .. url .. "\"'", function(_) end)
		else
			exec(
				'/bin/zsh -lc \'open "x-apple.systempreferences:com.apple.TimeMachine-Settings.extension" || open -a "Time Machine"\'',
				function(_) end
			)
		end
	end)
end)

action_open_tm:subscribe("mouse.clicked", function(_)
	exec("/bin/zsh -lc 'open -a \"Time Machine\"'", function(_) end)
end)

tm:subscribe("mouse.clicked", function(env)
	if env.BUTTON == "right" then
		sbar.exec("open 'x-apple.systempreferences:com.apple.TimeMachine-Settings.extension'")
		return
	end
	if env.BUTTON ~= "left" then
		return
	end
	popup.toggle(tm_bracket, populate_tm_details)
end)

popup.auto_hide(tm_bracket, tm)
