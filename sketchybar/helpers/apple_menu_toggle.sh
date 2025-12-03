#!/bin/bash

# Fast Apple menu toggle script
STATE_FILE="/tmp/sketchybar_apple_menu_state"

# Read current state (default to "closed" if file doesn't exist)
CURRENT_STATE="closed"
[ -f "$STATE_FILE" ] && CURRENT_STATE=$(cat "$STATE_FILE")

if [ "$CURRENT_STATE" = "closed" ]; then
    # Fast Apple menu open - try most reliable method first
    (
        osascript -e 'tell application "System Events" to click menu bar item 1 of menu bar 1 of application process "Finder"' 2>/dev/null ||
        osascript -e 'tell application "System Settings" to activate' 2>/dev/null
    ) &
    echo "open" > "$STATE_FILE"
else
    # Fast close with Escape key
    osascript -e 'tell application "System Events" to key code 53' 2>/dev/null &
    echo "closed" > "$STATE_FILE"
fi
