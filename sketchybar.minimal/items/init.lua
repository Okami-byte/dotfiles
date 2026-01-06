local colors = require("colors").sections
--left
require "items.apple"
require "items.menus"
require "items.spaces_yabai"
require "items.front_app_yabai"

sbar.add("bracket", { "/system\\..*/" }, {
  background = {
    height = 34,
    color = colors.bracket.bg,
    border_color = colors.bracket.border,
    corner_radius = 9999,
  },
})

--right (reverse order)
require "items.widgets"
