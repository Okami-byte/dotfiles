#!/usr/bin/env bash

# Paths
CONFIG_DIR="$HOME/.dotfiles/wezterm"
CONFIG_FILE="$CONFIG_DIR/floating_notes.lua"
SHARED_CONFIG="$CONFIG_DIR/floating_notes_config.json"

# Parse settings from shared JSON config
WINDOW_TITLE=$(jq -r '.window_title' "$SHARED_CONFIG")

# Query yabai for window with matching title
window_info=$(yabai -m query --windows | jq -r ".[] | select(.title == \"$WINDOW_TITLE\")")

if [[ -z "$window_info" ]]; then
  # No window found - open new WezTerm
  open -n /Applications/WezTerm.app --args --config-file "$CONFIG_FILE"
else
  window_id=$(echo "$window_info" | jq -r '.id')
  pid=$(echo "$window_info" | jq -r '.pid')
  has_focus=$(echo "$window_info" | jq -r '."has-focus"')
  is_hidden=$(echo "$window_info" | jq -r '."is-hidden"')

  if [[ "$is_hidden" == "true" ]]; then
    # Hidden - unhide and focus
    osascript -e "tell application \"System Events\" to set visible of (first process whose unix id is $pid) to true"
    yabai -m window "$window_id" --focus
  elif [[ "$has_focus" == "true" ]]; then
    # Visible and focused - hide it
    osascript -e "tell application \"System Events\" to set visible of (first process whose unix id is $pid) to false"
  else
    # Visible but not focused - focus it
    yabai -m window "$window_id" --focus
  fi
fi

exit 0
