#!/usr/bin/env bash

set -eou pipefail

for cmd in skhd yabai brew; do
  command -v "$cmd" >/dev/null 2>&1 || echo "Not found: $cmd"
done

for app in skhd yabai; do
  "$app" --restart-service || echo "$app : didn't work"
done

for serv in sketchybar borders; do
  brew services restart "$serv"
done
