#!/usr/bin/env bash

DEFAULT_TARGETS=(
	"speedtest.wtnet.de -p 5200 -P 10 -4 -R"
	"iperf.he.net -p 5201 -P 10 -4 -R"
	"+ custom"
)

SELECTED=$(gum choose --header="Select iPerf3 Target / Mode:" "${DEFAULT_TARGETS[@]}")

[ -z "$SELECTED" ] && exit 0

if [[ "$SELECTED" == "+ custom" ]]; then
	# Interaktiver Prompt mit Vorgabe "> iperf3 "
	EXTRA_ARGS=$(gum input --placeholder="-c 192.168.1.50 -p 5201 -P 4" --prompt="> iperf3 ")
	[ -z "$EXTRA_ARGS" ] && exit 0

	# Nutzt eval, damit gecquotete Args/Flags sauber getrennt werden
	eval "iperf3 $EXTRA_ARGS"
else
	# Führt das gewählte Preset mit -c aus
	eval "iperf3 -c $SELECTED"
fi
