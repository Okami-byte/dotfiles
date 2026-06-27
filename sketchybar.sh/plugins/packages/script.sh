#!/bin/bash

### Sum of Homebrew packages only

packages_total=$(($(ls /opt/homebrew/Caskroom 2>/dev/null | wc -l) + \
$(ls /opt/homebrew/Cellar 2>/dev/null | wc -l) + \
$(ls $HOME/local/Caskroom 2>/dev/null | wc -l) + \
$(ls $HOME/local/Cellar 2>/dev/null | wc -l)))

sketchybar --set $NAME label="$packages_total"
