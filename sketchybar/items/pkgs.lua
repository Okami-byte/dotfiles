local mod = {}

-- Setup
function mod.setup(icons, palette)
	mod.properties = {
		position = "right",
		update_freq = 300, -- 5 minutes

		icon = {
			string = icons.pkg,
			color = palette.text.primary,
		},

		label = {
			string = "?",
			y_offset = 0,
		},
	}

	return mod
end

local function update(item, icons, palette)
	return function(env)
		sbar.exec("/bin/zsh -lc 'brew update >/dev/null 2>&1; brew outdated 2>/dev/null'", function(result)
			local count = 0
			if result and result ~= "" then
				for _ in result:gmatch("[^\r\n]+") do
					count = count + 1
				end
			end

			local color = palette.text.primary
			if count >= 50 then
				color = palette.colors.red
			elseif count >= 30 then
				color = palette.colors.orange
			elseif count >= 10 then
				color = palette.colors.yellow
			elseif count >= 1 then
				color = palette.colors.cyan
			end

			local label = count == 0 and "􀆅" or tostring(count)

			item:set({
				icon = { color = color },
				label = { string = label },
			})
		end)
	end
end

-- Load
function mod.load(icons, palette)
	mod.item = sbar.add("item", mod.properties)

	mod.item:subscribe({ "routine", "forced" }, update(mod.item, icons, palette))

	return mod
end

return mod
