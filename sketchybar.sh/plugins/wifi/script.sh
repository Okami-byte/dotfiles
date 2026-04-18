#!/bin/bash
export RELPATH=$(dirname $0)/../..
source $RELPATH/set_colors.sh

WIFI_UNREDACTOR=$1

if ! command -v wifi-unredactor 2>/dev/null 1>&2 && [ -e "$WIFI_UNREDACTOR" ]; then
  alias wifi-unredactor="$WIFI_UNREDACTOR/Contents/MacOS/wifi-unredactor"
  echo 'using app'
fi

ICON_HOTSPOT=􀉤
ICON_WIFI=􀙇
ICON_WIFI_ERROR=􀙥
ICON_WIFI_OFF=􀙈

getname() {

  if command -v wifi-unredactor 2>/dev/null 1>&2; then # Check for wifi-unredactor in path (or as alias)
    WIFI_PORT=$(wifi-unredactor | jq -r .interface)
    WIFI=$(wifi-unredactor | jq -r .ssid)
    if [[ $WIFI == "failed to retrieve SSID" ]]; then WIFI=""; fi

  else # Fallback to old system : before macos 15.5
    WIFI_PORT=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
    WIFI="$(networksetup -listpreferredwirelessnetworks en0 | sed -n '2p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    #$(system_profiler SPAirPortDataType | awk '/Current Network/ {getline;$1=$1; gsub(":",""); print;exit}')
    #$(ipconfig getsummary $WIFI_PORT | awk -F': ' '/ SSID : / {print $2}')
  fi

  HOTSPOT=$(ipconfig getsummary $WIFI_PORT | grep sname | awk '{print $3}')
  IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
  PUBLIC_IP=$(
    curl -m 2 https://ipinfo.io 2>/dev/null 1>&2
    echo $?
  )

  ### Set icon according to wifi state

  if [[ $HOTSPOT != "" ]]; then
    ICON=$ICON_HOTSPOT
    ICON_COLOR=$GLOW
    LABEL=$HOTSPOT
  elif [[ $WIFI != "" ]]; then
    ICON=$ICON_WIFI
    ICON_COLOR=$BLUE
    LABEL="$WIFI"
  elif [[ $IP_ADDRESS != "" ]]; then
    ICON=$ICON_WIFI
    ICON_COLOR=$WARN
    LABEL="on"
  else
    ICON=$ICON_WIFI_OFF
    ICON_COLOR=$RED
    LABEL="off"
  fi

  ### If no access to internet change icon + add a notice to the label

  if [[ $PUBLIC_IP != "0" && $LABEL != "off" ]]; then
    ICON=$ICON_WIFI_ERROR
    ICON_COLOR=$SUBTLE
    LABEL="$WIFI (no internet)"
  fi

  wifi=(
    icon=$ICON
    label="$LABEL"
    icon.color=$ICON_COLOR
  )

  if [[ $WIFI == "<redacted>" ]]; then
    wifi+=(
      label.drawing=off
    )
    echo 'Wifi label hidden : redacted wifi ssid'
  else
    wifi+=(
      label.drawing=on
    )
  fi

  sketchybar --set $NAME "${wifi[@]}"
}

setscroll() {

  ### For performances, only scroll on hover

  STATE="$(sketchybar --query $NAME | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.geometry.scroll_texts')"

  case "$1" in
  "on")
    target="off"
    ;;
  "off")
    target="on"
    ;;
  esac

  if [[ "$STATE" == "$target" ]]; then
    sketchybar --set "$NAME" scroll_texts=$1
  fi

}

case "$SENDER" in
"mouse.entered")
  setscroll on
  ;;
"mouse.exited")
  setscroll off
  ;;
*)
  getname
  ;;
esac
