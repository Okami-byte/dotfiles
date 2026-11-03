#!/usr/bin/env bash

CONFIG_DIR="$HOME/.dotfiles/kitty/scripts"
CONFIG_FILE="$CONFIG_DIR/quick-access-terminal-center.conf"

# Toggles the scratchpad: first run launches it, later runs show/hide it
/opt/homebrew/bin/kitten quick-access-terminal \
  --instance-group scratch \
  -c "$CONFIG_FILE"

exit 0
