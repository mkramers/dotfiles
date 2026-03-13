#!/bin/bash
# Fuzzy tab switcher for kitty using fzf
# Launched as an overlay window so fzf renders inline

export PATH="$HOME/.local/share/aquaproj-aqua/bin:$HOME/.local/bin:$PATH"

kitty_sock="unix:/tmp/kitty-${KITTY_PID}"

selected=$(
  kitty @ --to "$kitty_sock" ls 2>/dev/null |
    jq -r '.[] | .tabs[] | "\(.id)\t\(.title)"' |
    fzf --with-nth=2.. --delimiter='\t' --prompt='tab> ' --no-multi --height=100% --reverse
) || exit 0

tab_id=$(echo "$selected" | cut -f1)
kitty @ --to "$kitty_sock" focus-tab --match "id:${tab_id}"
