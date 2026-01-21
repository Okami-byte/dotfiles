#!/bin/bash

##
# Yabai (macOS native) workspace windows indicator
# This script updates workspace labels to show app icons for windows in each workspace
#	This script is ran by the separator x times the number of worspaces,
# $INFO providing { "space": <spaceId>, "apps": { "<appName>": <numberOfWindows> } }
##

## Exports
export RELPATH=$(dirname $0)/../../..
source "$RELPATH/icon_map.sh"
if [[ -n "$SKETCHYBAR_CONFIG" && -f "$SKETCHYBAR_CONFIG" ]]; then
  source "$SKETCHYBAR_CONFIG"
elif [[ -f "$RELPATH/config.sh" ]]; then
  source "$RELPATH/config.sh"
fi
: "${HIDE_EMPTY_SPACES:=false}"

## Function definition

# Convert number to superscript
to_superscript() {
  local num=$1
  local result=""

  # Unicode superscript mapping
  declare -A sups=(
    [0]="⁰ "
    [1]="¹ "
    [2]="² "
    [3]="³ "
    [4]="⁴ "
    [5]="⁵ "
    [6]="⁶ "
    [7]="⁷ "
    [8]="⁸ "
    [9]="⁹ "
  )

  # Convert each digit
  while [ -n "$num" ]; do
    digit="${num:0:1}"
    result="${result}${sups[$digit]}"
    num="${num:1}"
  done

  echo "$result"
}

# Toggle space icon strip visibility
toggle_space_visibility() { # $1 -> true/false $2 -> spaceIndex
  local state=$1
  local space="$2"

  visible_spaces=($(yabai -m query --spaces | jq -r '.[] | select(.["is-visible"] == true) | .index'))

  if $state; then
    # When switching space on

    if [[ "${visible_spaces[*]}" =~ "$space" ]]; then
      # If space is visible, no background
      sketchybar --set space.$space \
        background.drawing=off
    else
      # If space is not visible, background
      sketchybar --set space.$space \
        background.drawing=on

      # If space was empty before, play animation
      if [[ $(sketchybar --query space.$space | jq -r .label.drawing) == "off" ]]; then
        sketchybar --set space.$space label.width=0 label.drawing=on
        sketchybar --animate tanh 20 --set space.$space label.width=dynamic
      fi
    fi

  else
    # When switching space off

    if [[ "${visible_spaces[*]}" =~ "$space" && $HIDE_EMPTY_SPACES ]]; then
      # If empty spaces are hidden but space is selected, draw anyaway
      sketchybar --set space.$space drawing=on
    elif $HIDE_EMPTY_SPACES; then
      sketchybar --set space.$space drawing=off
    fi
    sketchybar --set space.$space label.drawing=off background.drawing=off

  fi
}

# Set space item style & label
update_workspace_windows() {
  # Get space and active apps
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    # If there are active apps, make label

    while read -r app; do
      # Get the count for this app
      count="$(echo "$INFO" | jq -r ".apps[\"$app\"]")"

      # Get the icon for this app
      __icon_map "$app"
      icon="$icon_result"

      # Add superscript count if more than 1 instance
      if [ "$count" -gt 1 ]; then
        superscript="$(to_superscript "$count")"
        icon_strip+=" ${superscript}${icon}"
      else
        icon_strip+=" ${icon}"
      fi
    done <<<"${apps}"
    sketchybar --set space.$space label="$icon_strip"

    # If there are active apps, show label
    toggle_space_visibility true $space
  else
    sketchybar --set space.$space label="$icon_strip"
    # If there's no active apps, don't show label
    toggle_space_visibility false $space
  fi
}

## Main logic
if [ "$SENDER" = "space_windows_change" ]; then
  update_workspace_windows
fi
