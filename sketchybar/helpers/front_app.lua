-- Front-app item behaviour shared by items/spaces.lua and items/spaces_icons.lua (yabai).
--
-- Shows the focused app's icon and name. When the focused window is part of a
-- yabai stack, the label gets its position appended, e.g. "kitty  2/3".
-- Updates on front_app_switched and on yabai's window_focus signal (yabairc),
-- so cycling through a stack of the same app updates too.

local app_icons = require("helpers.app_icons")

local M = {}

local function sameFrame(a, b)
	return a.x == b.x and a.y == b.y and a.w == b.w and a.h == b.h
end

local function update(item, app)
	sbar.exec((execs.yabai or "yabai") .. " -m query --windows --space", function(windows)
		local label = app
		local focused
		if type(windows) == "table" then
			for _, w in ipairs(windows) do
				if w["has-focus"] then
					focused = w
					break
				end
			end
		end

		if focused then
			app = app or focused.app
			label = app
			local index = focused["stack-index"] or 0
			if index > 0 then
				local count = 0
				for _, w in ipairs(windows) do
					if (w["stack-index"] or 0) > 0 and sameFrame(w.frame, focused.frame) then
						count = count + 1
					end
				end
				label = string.format("%s  %d/%d", app, index, count)
			end
		end

		if label then
			item:set({
				icon = { string = app_icons[app] or app_icons["default"] },
				label = { string = label },
			})
		end
	end)
end

function M.attach(item)
	sbar.add("event", "window_focus") -- triggered by the window_focused signal in yabairc
	item:subscribe("front_app_switched", function(env)
		update(item, env.INFO)
	end)
	item:subscribe("window_focus", function()
		update(item, nil)
	end)
end

return M
