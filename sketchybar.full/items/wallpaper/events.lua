local globals = require("items.wallpaper.globals")
local helpers = require("items.wallpaper.helpers")
local components = require("items.wallpaper.components")

-- Key events
sbar.add("event", "request_bg")
sbar.add("event", "cycle_bg")
sbar.add("event", "select_bg")

components.bg:subscribe("request_bg", function(env)
	helpers.setAnchorText()
	local requested = env.REQUEST_BG == "true"

	components.bg:set({ popup = { drawing = requested } })
	components.bgAnchor:set({ popup = { drawing = requested } })
	components.previewAnchor:set({ popup = { drawing = requested } })

	local tbl = helpers.seekTbl(requested)
	helpers.entryToggle(tbl, false, requested)
end)

components.bg:subscribe("cycle_bg", function(env)
	if env.CYCLE == "next" then
		helpers.cycleNext()
	else
		helpers.cyclePrev()
	end
end)

local function setWallpaper()
	-- Simple approach: set wallpaper for all desktops
	local cmd = [[osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"]]
		.. globals.selectedFilePath
		.. [[\" as POSIX file"]]
	
	os.execute(cmd)
end

components.bg:subscribe("select_bg", function(env)
	if env.SELECT == "true" then
		local tbl = helpers.getFocusedEntryTbl()
		local target = tbl.getSelected()
		
		if target and target["FILE_PATH"] and not target["DIR_FILES"] then
			-- We're selecting a file (wallpaper), set it and exit
			globals.selectedFilePath = target["FILE_PATH"]
			helpers.entryToggle(tbl, true, true)
			sbar.exec('skhd -k "ctrl - b"')
			setWallpaper()
		else
			-- We're selecting a directory, navigate into it
			helpers.entryToggle(tbl, true, true)
			globals.depth = globals.depth + 1
		end
	else
		if globals.depth > 1 then
			-- Moved out one directory
			globals.depth = globals.depth - 1

			-- We just need the table
			local tbl = helpers.getFocusedEntryTbl()

			-- Unset highlight
			helpers.entryToggle(tbl, false, true)
		else
			sbar.exec('skhd -k "ctrl - b"')
		end
	end
end)
