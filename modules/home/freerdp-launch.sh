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

if [ -n "$RDP_HOST" ]; then
	HOST_IP="${RDP_HOST%%:*}"
	PORT="${RDP_HOST##*:}"
	[ "$PORT" = "$HOST_IP" ] && PORT=3389

	if ! timeout 2 bash -c "cat < /dev/null > /dev/tcp/$HOST_IP/$PORT" 2>/dev/null; then
		if command -v notify-send >/dev/null; then
			notify-send -u critical "FreeRDP Error" "Host $HOST_IP is not reachable on port $PORT"
		fi
		echo "Error: Host $HOST_IP not reachable on port $PORT" >&2
		exit 1
	fi
fi

PASS=""
if [ -n "$RDP_HOST" ] && command -v rbw >/dev/null; then
	PASS=$(rbw get "$(rbw search "$RDP_HOST" 2>/dev/null)" 2>/dev/null || echo "")
fi

[ -n "$PASS" ] && ARGS+=("/p:$PASS")

if [ -n "${WAYLAND_DISPLAY:-}" ]; then
	CLIENT="sdl-freerdp"
else
	CLIENT="xfreerdp"
fi

set +e
"$CLIENT" "${ARGS[@]}"
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -ne 0 ]; then
	if command -v notify-send >/dev/null; then
		notify-send -u critical "FreeRDP Error" "Connection failed for $RDP_HOST (Exit: $EXIT_CODE)"
	fi
	exit $EXIT_CODE
fi
