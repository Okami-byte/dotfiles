#!/bin/bash
export RELPATH=$(dirname $0)/../..;
source $RELPATH/set_colors.sh

GITHUB_TOKEN=$1 # (~/.github_token)

# Check for github token 
if [[ -f $1 ]]; then
	GITHUB_TOKEN_TEXT="$(cat $1)" # Should be a PAT with only notification reading permissions
  # Get all user's notifications
  notifications="$(curl -m 15 -s \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN_TEXT" \
    https://api.github.com/notifications )"
  
  curlSuccess=$?

  count=$(echo $notifications | jq '. | length')

  item=(
    label="$count"
  )

  ### Set icon + label depending on success and notification number

  if [[ $curlSuccess != 0 ]];then 
    item+=(
      icon=􀋞
      icon.color=$SUBTLE
      label="--"
    )
  elif [ $count -gt 0 ]; then
    item+=(
      icon=􀝗
      icon.color=$RED
    )
  else 
    item+=(
      icon=􀋚
      icon.color=$BLUE
    )
  fi

  sketchybar --set "$NAME" "${item[@]}"
else

  ### If No github token, hide the menu item
  item=(
    width=0
		label.drawing="off"
		icon.drawing="off"
  )
  sketchybar --set "$NAME" "${item[@]}"
fi
