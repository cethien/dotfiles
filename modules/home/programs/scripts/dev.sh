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

tmux new-session -d -s "$(basename "$DIR")" "cd $DIR && bash" \; \
    split-window -v -p 25 "cd $DIR && bash" \; \
    split-window -h -p 50 "cd $DIR && bash" \; \
    send-keys -t 0 "$EDITOR ." C-m \; \
    attach \; \
    select-pane -t 0
