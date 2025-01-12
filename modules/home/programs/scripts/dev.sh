#!/usr/bin/env bash

usage() {
    echo "Usage: $0 <dir>"
    echo ""
    echo "Parameters:"
    echo "  <dir>               Directory to open editor in"
}

DIR=${1:-$PWD}
DIR=$(realpath "$DIR")

if [[ -z $DIR ]]; then
    usage
    exit 1
fi

if [[ ! -d $DIR ]]; then
    echo "Error: Directory $DIR does not exist"
    exit 1
fi

cd $DIR && tmux new-session -d -s "$(basename "$DIR")" "bash" \; \
    split-window -v -p 15 "bash" \; \
    split-window -h -p 50 "bash" \; \
    send-keys -t 0 "$EDITOR ." C-m \; \
    new-window -n "lazygit" "lazygit" \; \
    select-pane -t 0 \; \
    attach
