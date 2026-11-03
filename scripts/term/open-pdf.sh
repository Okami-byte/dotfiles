#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    dir=$(tmux run "echo #{pane_start_path}")
    selected=$(find $dir ~/Downloads ~/Desktop/School/25-26 -mindepth 1 -maxdepth 1 -name "*.pdf" | \
        sed "s|^$HOME/||" | \
        fzf --no-color
    )

    # Add home path back
    if [[ -n "$selected" ]]; then
        selected="$HOME/$selected"
    fi
fi

if [[ -z "$selected" ]]; then
    exit 1
fi

selected_name=$(basename "$selected" | tr . _)

tmux new-window -n "$selected_name" -d zathura "$selected"
tmux select-window -l
