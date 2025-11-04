local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

sbar.exec("sketchybar --add event brew_update")

local brew = sbar.add("item", "brew", {
	position = "right",
	icon = {
		string = icons.brew,
		color = colors.white,
	},
	label = {
		string = "?",
	},
	update_freq = 60,
	popup = {
		align = "right",
		height = 20,
	},
})

-- popup header
local brew_details = sbar.add("item", "brew.details", {
	position = "popup." .. brew.name,
	icon = { drawing = false },
	label = {
		string = "Outdated Brews",
		align = "left",
		color = colors.maroon,
	},
	background = {
		corner_radius = 12,
		padding_left = 5,
		padding_right = 10,
	},
})

-- brew item
local function get_brew_count()
	local result = brew:query()
	if result and result.popup and result.popup.items then
		local count = 0
		for _, item in ipairs(result.popup.items) do
			if item:match("^brew%.package%.") then
				count = count + 1
			end
		end
		return count
	end
	return 0
end

-- bar item
local function render_bar_item(count)
	local color = colors.green
	local label = icons.brew_check

	if count >= 30 then
		color = colors.red
		label = tostring(count)
	elseif count >= 10 then
		color = colors.peach
		label = tostring(count)
	elseif count >= 1 then
		color = colors.yellow
		label = tostring(count)
	end

	brew:set({
		icon = { color = color },
		label = { string = label },
	})
end

local function render_popup(outdated)
	sbar.remove("/brew.package\\..*/")

	if outdated and outdated ~= "" then
		local counter = 0
		for package in outdated:gmatch("[^\r\n]+") do
			if package ~= "" then
				sbar.add("item", "brew.package." .. counter, {
					position = "popup." .. brew.name,
					icon = { drawing = false },
					label = {
						string = package,
						align = "right",
						padding_left = 20,
						color = colors.yellow,
					},
				})
				counter = counter + 1
			end
		end
	end
end

local function update(sender)
	local prev_count = get_brew_count()
	-- before checking outdated, run brew update
	sbar.exec("/bin/zsh -lc 'brew update'", function()
		sbar.exec("/bin/zsh -lc 'brew outdated'", function(outdated)
			local count = 0
			if outdated and outdated ~= "" then
				for _ in outdated:gmatch("[^\r\n]+") do
					count = count + 1
				end
			end

			render_bar_item(count)
			render_popup(outdated)

			-- 如果数量变化或强制更新，添加动画
			if count ~= prev_count or sender == "forced" then
				sbar.animate("tanh", 15, function()
					brew:set({ label = { y_offset = 5 } })
					brew:set({ label = { y_offset = 0 } })
				end)
			end
		end)
	end)
end

-- popup
local function toggle_popup(should_draw)
	local count = get_brew_count()
	if count > 0 then
		brew:set({ popup = { drawing = should_draw } })
	else
		brew:set({ popup = { drawing = false } })
	end
end

-- 订阅事件
brew:subscribe("routine", function()
	update("routine")
end)

brew:subscribe("forced", function()
	update("forced")
end)

brew:subscribe("brew_update", function()
	update("brew_update")
end)

brew:subscribe("mouse.entered", function()
	toggle_popup("on")
end)

brew:subscribe("mouse.exited", function()
	toggle_popup("off")
end)

brew:subscribe("mouse.exited.global", function()
	toggle_popup("off")
end)

brew:subscribe("mouse.clicked", function()
	toggle_popup("toggle")
end)

brew_details:subscribe("mouse.clicked", function()
	brew:set({ popup = { drawing = false } })
end)
