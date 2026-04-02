#!/bin/bash
# Toggle-minimize the current kitty window (shrink to ~4 lines or restore)
STATE_FILE="/tmp/kitty-minimize-${KITTY_WINDOW_ID}"
SOCK="--to=${KITTY_LISTEN_ON}"

if [ -f "$STATE_FILE" ]; then
    kitty @ "$SOCK" resize-window --self --axis reset
    rm "$STATE_FILE"
else
    touch "$STATE_FILE"
    kitty @ "$SOCK" resize-window --self --increment -1000 --axis vertical
    kitty @ "$SOCK" resize-window --self --increment 4 --axis vertical
fi
