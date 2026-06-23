local mod = {}

local display_groups = {
  ["Built-in"]                 = "􁈸",
  ["External"]                 = "􀢹",
  ["Built-in + External"]      = "􂤓",
  ["Dual External"]            = "􀨧",
  ["Built-in + Dual External"] = "􁑭",
}

-- Setup
function mod.setup(items, icons)
  mod.properties = {
    position = "right",
    padding_right = items.config.margin - 1,
    icon = {
      string        = icons.display.default,
      padding_right = 1
    },
    label = {
      drawing = false
    }
  }

  return mod
end

local function bd_update(item)
  return function(env)
    sbar.exec("pgrep BetterDisplay", function(result, exit_code)
      if exit_code ~= 0 then
        item:set({ drawing = false })
        return
      end

      local groups = (config.display_groups ~= nil and next(config.display_groups) ~= nil)
        and config.display_groups
        or display_groups

      for name, icon in pairs(groups) do
        local icon_str = type(icon) == "table" and icon.icon or icon
        sbar.exec(
          "printf \"%s\" \"$(" .. execs.bd_cli .. " get --name=\"" .. name .. "\" --active)\"",
          function(active, _)
            if active == "on" then
              item:set({ icon = { string = icon_str }, drawing = true })
            end
          end
        )
      end
    end)
  end
end

-- Load
function mod.load()
  mod.item = sbar.add("item", mod.properties)

  if execs.bd_cli then
    if shellEval("pgrep BetterDisplay") == "" then
      mod.item:set({ drawing = false })
    end

    mod.item:subscribe("mouse.clicked", function(env)
      sbar.exec(execs.bd_cli .. " toggle --appmenu")
    end)

    mod.item:subscribe({ "display_change", "forced", "system_woke" }, bd_update(mod.item))
    bd_update(mod.item)({})
  else
    mod.item:subscribe("mouse.clicked", function(env)
      sbar.exec(execs.menubar .. " -s " .. menu_items.display)
    end)
  end

  return mod
end

return mod
