local M = { _registry = {} }

function M.register(item)
	if item and item.name then
		M._registry[item.name] = item
	end
	return item
end

local function hide_all_except(target)
	for name, ref in pairs(M._registry) do
		if name ~= target.name then
			pcall(function()
				ref:set({ popup = { drawing = false } })
			end)
		end
	end
end

function M.hide(item)
	if not item then
		return
	end
	item:set({ popup = { drawing = false } })
end

function M.show(item, on_show)
	if not item then
		return
	end
	hide_all_except(item)
	if on_show then
		on_show()
	end
	item:set({ popup = { drawing = true } })
end

function M.toggle(item, on_show)
	if not item then
		return
	end
	local drawing = item:query().popup.drawing
	if drawing == "off" then
		M.show(item, on_show)
	else
		M.hide(item)
	end
end

function M.auto_hide(bracket, widget)
	-- If only one argument provided, assume it's the bracket
	if not widget then
		widget = bracket
	end

	if not bracket then
		return
	end

	-- Subscribe mouse.exited.global to the widget (following wifi pattern)
	widget:subscribe("mouse.exited.global", function(_)
		M.hide(bracket)
	end)

	-- These can stay on the bracket
	bracket:subscribe("front_app_switched", function(_)
		M.hide(bracket)
	end)
	bracket:subscribe("space_change", function(_)
		M.hide(bracket)
	end)
end

return M
