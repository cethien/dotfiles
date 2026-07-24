#!/usr/bin/env bash

TARGET="${1:-}"

if [ -z "$TARGET" ]; then
	read -r -e -p "portscan target: " TARGET
else
	echo "portscan target: $TARGET"
fi

if [ -z "$TARGET" ]; then
	echo "no target provided"
	exit 1
fi

echo ""

rustscan --no-banner --ulimit 5000 -a "$TARGET"
