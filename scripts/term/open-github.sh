#!/usr/bin/env bash

# Open the current repository in the browser
dir=$(tmux run "echo #{pane_start_path}")
cd "$dir" || exit 1
url=$(git remote get-url origin)

if [[ "$url" == git@github.com:* ]]; then
    clean_url="https://github.com/${url#git@github.com:}"
    clean_url="${clean_url%.git}"
    open $clean_url
else
    clean_url="${url%.git}"
fi

# Check if the repository is on GitHub
if [[ $url == *"github.com"* ]]; then
  open $url
else
  echo "This repository is not hosted on GitHub"
fi
