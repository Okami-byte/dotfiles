#!/bin/bash
# list_nix_packages() {
#   for x in $(nix-store --query --requisites "$1" 2>/dev/null); do
#     if [ -d "$x" ]; then
#       echo "$x"
#     fi
#   done | cut -d- -f2- |
#     egrep '([0-9]{1,}\.)+[0-9]{1,}' |
#     egrep -v '\-doc$|\-man$|\-info$|\-dev$|\-bin$|^nixos-system-nixos-' |
#     uniq |
#     wc -l
# }

### Sum of all packages

packages_total=$((\
  $(ls /opt/homebrew/Caskroom 2>/dev/null | wc -l) + \
  $(ls /opt/homebrew/Cellar 2>/dev/null | wc -l) + \
  $(ls $HOME/local/Caskroom 2>/dev/null | wc -l) + \
  $(ls $HOME/local/Cellar 2>/dev/null | wc -l))) # Nix default + Nix system + Nix user

sketchybar --set $NAME label="$packages_total"
