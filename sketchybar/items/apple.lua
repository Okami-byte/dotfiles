local colors = require("colors").sections
local icons = require "icons"
local settings = require "settings"

local apple = sbar.add("item", "system.apple", {
  padding_left = 4,
  icon = {
    font = { size = 14 },
    string = icons.apple,
    padding_right = 4,
    padding_left = 4,
    color = colors.apple.icon,
  },
  background = {
    color = colors.apple.bg,
    corner_radius = 9999,
  },
  label = { drawing = false },
  -- click_script = "$CONFIG_DIR/helpers/apple_menu_toggle.sh",
})

-- Helper function to create menu items with hover effect
local function create_menu_item(position, label, icon_string, click_command)
  local item = sbar.add("item", {
    position = position,
    icon = {
      string = icon_string,
      padding_left = 5,
      padding_right = 15,
      color = colors.arise,
    },
    label = {
      string = label,
      color = colors.arise,
      padding_left = 5,
      padding_right = 20,
      align = "left",
      font = { size = 12 },
    },
    background = {
      padding_left = 10,
      padding_right = 15,
      color = colors.bg,
      border_color = colors.transparent,
      height = 40, -- Reduced height for compactness
      width = popup_width,
    },
    click_script = click_command,
  })

  -- Hover effect
  item:subscribe("mouse.entered", function()
    sbar.animate("elastic", 5, function()
      item:set {
        icon = {
          padding_left = 5,
          padding_right = 15,
          color = colors.purple,
          font = { size = 16 },
        },
        label = {
          color = colors.grey,
          padding_left = 10,
          padding_right = 20,
          align = "left",
          font = { size = 12, style = "Bold" },
        },
      }
    end)
  end)
  item:subscribe("mouse.exited", function()
    sbar.animate("elastic", 15, function()
      item:set {
        icon = {
          padding_left = 5,
          padding_right = 15,
          font = { size = 14 },
          color = colors.arise,
        },
        label = {
          padding_left = 10,
          padding_right = 20,
          string = label,
          color = colors.arise,
          align = "left",
          font = { size = 12 },
        },
      }
    end)
  end)

  return item
end

-- Add each custom menu entry to the popup
local about_mac = create_menu_item("popup." .. apple.name, "About", icons.user, "open -a 'About This Mac'")
local system_settings = create_menu_item("popup." .. apple.name, "Settings", icons.gear, "open -a 'System Preferences'")
local force_quit = create_menu_item(
  "popup." .. apple.name,
  "Force Quit",
  icons.circle_quit,
  'osascript -e \'tell application "System Events" to keystroke "q" using {command down}\''
)
-- local sleep = create_menu_item("popup." .. apple.name, "Sleep", icons.circle_sleep, "pmset displaysleepnow")
local restart = create_menu_item(
  "popup." .. apple.name,
  "Restart",
  icons.circle_restart,
  "osascript -e 'tell app \"System Events\" to restart'"
)
local shutdown = create_menu_item(
  "popup." .. apple.name,
  "Power off",
  icons.circle_shutdown,
  "osascript -e 'tell app \"System Events\" to shut down'"
)
local lock = create_menu_item(
  "popup." .. apple.name,
  "Lock",
  icons.lock,
  'osascript -e \'tell application "System Events" to keystroke "q" using {command down, control down}\''
)

-- Toggles popup on click
apple:subscribe("mouse.clicked", function(env)
  sbar.animate("elastic", 15, function()
    apple:set {
      popup = {
        y_offset = 0,
        height = 0,
        drawing = "toggle",
      },
    }
  end)
end)

-- Hides popup on mouse exit
apple:subscribe("mouse.exited.global", function(env)
  sbar.animate("elastic", 15, function()
    apple:set {
      popup = {
        y_offset = -10,
        height = 0,
        drawing = false,
      },
    }
  end)
end)

return apple
