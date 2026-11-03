#!/usr/bin/env bash

CONFIG_DIR="$HOME/.dotfiles/kitty/scripts"
CONFIG_FILE="$CONFIG_DIR/quick-access-terminal-daily.conf"
NOTES_DIR="$HOME/Notes/04 - Daily"

# Toggles the daily note: first run launches nvim, later runs show/hide it
# shellcheck disable=SC2016  # $1 is meant to expand inside sh -c
/opt/homebrew/bin/kitten quick-access-terminal \
  --instance-group daily \
  -c "$CONFIG_FILE" \
  sh -c 'cd "$1" && exec /opt/homebrew/bin/nvim -c "Obsidian today"' _ "$NOTES_DIR"

exit 0
