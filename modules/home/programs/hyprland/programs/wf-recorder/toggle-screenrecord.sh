#!/bin/env bash

pgrep -x "wf-recorder" && pkill -INT -x wf-recorder && exit 0

mkdir -p $HOME/Videos/Screencaptures
dateTime=$(date +%Y-%m-%d_%H%M%S)
wf-recorder --bframes max_b_frames -f $HOME/Videos/Screencaptures/$dateTime.mkv
