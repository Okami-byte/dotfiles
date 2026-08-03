local mod = {}

-- Setup
function mod.setup(icons, palette)
	mod.properties = {
		alias = {
			position = "right",
			padding_left = -4,
			padding_right = -4,

			icon = { drawing = false },
			label = { drawing = false },
		},
		control_center = {
			position = "right",

			icon = {
				string = icons.control_center,
				color = palette.text.primary,
			},

			label = {
				drawing = false,
			},
		},
	}

	mod.items = {}
	return mod
end

-- Load
function mod.load()
	local item = sbar.add("item", mod.properties.control_center)
	item:subscribe("mouse.clicked", function(env)
		sbar.exec([[osascript -e '
			tell application "System Events"
				tell process "MenuBarAgent"
					repeat with g in every group of menu bar 1
						repeat with theItem in every menu bar item of g
							try
								if (value of attribute "AXIdentifier" of theItem) is "com.apple.menuextra.controlcenter" then
									click theItem
									return
								end if
							end try
						end repeat
					end repeat
				end tell
			end tell
		']])
	end)

	mod.control_center = item
	return mod
end

function mod.alias(alias_name)
	local item = sbar.add("alias", alias_name, mod.properties.alias)
	item:subscribe("mouse.clicked", function(env)
		sbar.exec(execs.menubar .. ' -s "' .. alias_name .. '"')
	end)

	mod.items[alias_name] = item
	return mod
end

return mod
