local with_alpha = require("colors").with_alpha
local colors = require("colors").sections
local icon_map = require "helpers.icon_map"

-- Padding for e position
sbar.add("item", "e_bracket.padding", {
  position = "e",
  background = {
    drawing = false,
  },
  width = 12,
})

-- Add custom events for window management
sbar.add("event", "window_focus")
sbar.add("event", "title_change")

-- Function to truncate strings to a max length and add dots if needed
local function truncate_string(str, max_length)
  if #str > max_length then
    return str:sub(1, max_length) .. "…"
  else
    return str
  end
end

local function update_windows(windows)
  sbar.remove "/front_app\\..*window\\..*/"

  -- Filter windows to exclude certain apps without titles
  local filtered_windows = {}
  for _, window in ipairs(windows) do
    if
      not (
        (
          window["app"] == "Zen Browser"
          or window["app"] == "Twilight"
          or window["app"] == "Firefox"
          or window["app"] == "FiveNotes"
          or window["app"] == "kitty"
          or window["app"] == "WezTerm"
          or window["app"] == "Ghostty"
          or window["app"] == "Arc"
        ) and (window["title"] == nil or window["title"] == "")
      )
    then
      table.insert(filtered_windows, window)
    end
  end

  local max_length

  -- Filter titles if too many windows
  local count = #filtered_windows
  if count > 4 then
    max_length = nil -- Show only the app name
  elseif count > 3 then
    max_length = 5
  elseif count > 2 then
    max_length = 15
  elseif count > 1 then
    max_length = 25
  else
    max_length = 50
  end

  for _, window in ipairs(filtered_windows) do
    local window_label
    if max_length then
      window_label = truncate_string(window["app"], max_length)
    else
      window_label = window["app"]
    end

    -- Fetch the icon for the app
    local icon_lookup = icon_map[window["app"]]
    local icon = icon_lookup or icon_map["default"] or window["app"]:sub(1, 1)

    sbar.add("item", "front_app.window." .. window["id"], {
      position = "e",
      display = "active",
      icon = {
        font = "sketchybar-app-font:Regular:14.0",
        string = icon,
        padding_left = 8,
        padding_right = 4,
        color = colors.front_app.icon,
      },
      label = {
        string = window_label,
        padding_left = 4,
        padding_right = 8,
        color = window["has-focus"] and colors.apps.focused or colors.apps.unfocused,
        highlight_color = colors.apps.focused,
        highlight = window["has-focus"],
      },
      background = {
        color = colors.bracket.bg,
        height = 34,
        border_color = colors.bracket.border,
        corner_radius = 9999,
      },
      click_script = "yabai -m window --focus " .. window["id"],
    })
  end
end

local function get_apps()
  sbar.exec("yabai -m query --windows --space", function(output)
    update_windows(output)
  end)
end

-- Bracket for all front app windows
sbar.add("bracket", { "/front_app\\.window\\..*/" }, {
  background = {
    color = colors.bracket.bg,
    height = 34,
    border_color = colors.bracket.border,
    corner_radius = 9999,
  },
})

-- Subscribe to events
local front_app_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

front_app_observer:subscribe("space_change", get_apps)
front_app_observer:subscribe("front_app_switched", get_apps)
front_app_observer:subscribe("title_change", get_apps)
front_app_observer:subscribe("window_focus", get_apps)
