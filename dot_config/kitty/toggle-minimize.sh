#!/bin/bash
# Toggle-minimize the current kitty window (shrink to ~3 lines or restore)
STATE_FILE="/tmp/kitty-minimize-${KITTY_WINDOW_ID}"

if [ -f "$STATE_FILE" ]; then
    kitty @ resize-window --self --axis reset
    rm "$STATE_FILE"
else
    touch "$STATE_FILE"
    kitty @ resize-window --self --increment -1000 --axis vertical
fi
