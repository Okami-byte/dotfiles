#!/usr/bin/env bash

CONFIG_DIR="$HOME/.dotfiles/wezterm"
CONFIG_FILE="$CONFIG_DIR/floating_terminal.lua"
WINDOW_TITLE="floaterm"

window_info=$(yabai -m query --windows | jq -r ".[] | select(.title == \"$WINDOW_TITLE\")")

if [[ -z "$window_info" ]]; then
  open -n /Applications/WezTerm.app --args --config-file "$CONFIG_FILE"
else
  window_id=$(echo "$window_info" | jq -r '.id')
  pid=$(echo "$window_info" | jq -r '.pid')
  has_focus=$(echo "$window_info" | jq -r '."has-focus"')
  is_hidden=$(echo "$window_info" | jq -r '."is-hidden"')

  if [[ "$is_hidden" == "true" ]]; then
    osascript -e "tell application \"System Events\" to set visible of (first process whose unix id is $pid) to true"
    yabai -m window "$window_id" --focus
  elif [[ "$has_focus" == "true" ]]; then
    osascript -e "tell application \"System Events\" to set visible of (first process whose unix id is $pid) to false"
  else
    yabai -m window "$window_id" --focus
  fi
fi

exit 0
