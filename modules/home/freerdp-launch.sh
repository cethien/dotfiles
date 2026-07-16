#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"

if [ -z "$TARGET" ]; then
	echo "Usage: $0 <path-to-rdp-file | host-or-ip>" >&2
	exit 1
fi

ARGS=(
	"-wallpaper"
	"-themes"
	"-fonts"
	"/bpp:16"
	"/network:lan"
	"+auto-reconnect"
	"+clipboard"
	"/printer"
	"+workarea"
	"+dynamic-resolution"
	"/cert:ignore"
)

if [ -f "$TARGET" ]; then
	RDP_HOST=$(awk -F':' '/^full address:s:/ {print $NF}' "$TARGET" | tr -d '\r\n')
	ARGS=("$TARGET" "${ARGS[@]}")
else
	RDP_HOST="$TARGET"
	ARGS=("/v:$RDP_HOST" "${ARGS[@]}")
fi

PASS=""
if [ -n "$RDP_HOST" ] && command -v secret-tool >/dev/null; then
	PASS=$(secret-tool lookup URL "$RDP_HOST" 2>/dev/null || echo "")
fi

[ -n "$PASS" ] && ARGS+=("/p:$PASS")

if [ -n "${WAYLAND_DISPLAY:-}" ]; then
	exec sdl-freerdp "${ARGS[@]}"
else
	exec xfreerdp "${ARGS[@]}"
fi
