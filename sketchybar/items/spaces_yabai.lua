local with_alpha = require("colors").with_alpha
local colors = require("colors").sections
local icons = require "icons"
local settings = require "settings"
local icon_map = require "helpers.icon_map"

-- Padding for left/q position
sbar.add("item", "q_bracket.padding", {
  position = "q",
  background = {
    drawing = false,
  },
  width = 12,
})

local spaces = {}

for i = 10, 1, -1 do
  local icon_index = math.fmod(i - 1, #colors.spaces.icon) + 1
  local icon_color = colors.spaces.icon[icon_index]

  local space = sbar.add("space", "space." .. i, {
    position = "q",
    space = i,
    icon = {
      font = { family = settings.font.icons },
      string = i,
      padding_left = 5,
      padding_right = 7,
      color = icon_color,
      highlight_color = icon_color,
    },
    label = {
      drawing = false,
      padding_right = 8,
      color = colors.apps.unfocused,
      highlight_color = colors.apps.focused,
      font = "sketchybar-app-font:Regular:14.0",
    },
    background = {
      color = with_alpha(icon_color, 0.2),
      corner_radius = 9999,
      height = 26,
    },
  })

  spaces[i] = space

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left = 5,
    padding_right = 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2,
      },
    },
  })

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    sbar.animate("circ", 15, function()
      space:set {
        icon = {
          highlight = selected,
          string = selected and icons.space_indicator.on or icons.space_indicator.off,
          color = selected and icon_color or icon_color,
        },
      }
    end)
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set { background = { image = "space." .. env.SID } }
      space:set { popup = { drawing = "toggle" } }
    else
      local op = (env.BUTTON == "right") and "--destroy" or "--focus"
      sbar.exec("yabai -m space " .. op .. " " .. env.SID)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set { popup = { drawing = false } }
  end)
end

-- Bracket for all spaces
sbar.add("bracket", { "/space\\..*/" }, {
  background = {
    height = 34,
    color = colors.bracket.bg,
    border_color = colors.bracket.border,
    corner_radius = 9999,
  },
})

-- Spaces indicator
local spaces_indicator = sbar.add("item", "system.spaces_indicator", {
  icon = {
    string = icons.switch.on,
    color = colors.menu.fg,
    padding_left = 8,
    padding_right = 8,
  },
  label = {
    drawing = false,
  },
  background = {
    color = colors.menu.bg,
    corner_radius = 9999,
  },
  padding_left = 4,
})

local spaces_indicator = sbar.add("item", "system.spaces_indicator", {
  icon = {
    string = icons.switch.on,
    color = colors.menu.fg,
    padding_left = 8,
    padding_right = 8,
  },
  label = {
    drawing = false,
  },
  background = {
    color = colors.menu.bg,
    corner_radius = 9999,
  },
  padding_left = 4,
})

spaces_indicator:subscribe("display_menu", function()
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set {
    icon = currently_on and icons.switch.off or icons.switch.on,
  }
end)

spaces_indicator:subscribe("mouse.clicked", function()
  sbar.trigger "display_menu"
end)
