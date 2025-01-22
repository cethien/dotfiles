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

SESSION=$(basename "$DIR")
if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux attach -t "$SESSION"
else
    cd $DIR && tmux new-session -d -s "$SESSION" "bash" \; \
        split-window -v -p 20 "bash" \; \
        send-keys -t 0 "$EDITOR ." C-m \; \
        attach
fi
