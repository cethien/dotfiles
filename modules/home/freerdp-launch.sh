#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"

if [ -z "$TARGET" ]; then
	echo "Usage: $0 <path-to-rdp-file | host-or-ip>" >&2
	exit 1
fi

WIDTH=""
HEIGHT=""
if command -v hyprctl >/dev/null && [ -n "${WAYLAND_DISPLAY:-}" ]; then
	RES=$(hyprctl monitors -j | jq -r '.[0] | "\(.width) \(.height)"' 2>/dev/null || echo "")
	if [ -n "$RES" ]; then
		WIDTH=$(echo "$RES" | awk '{print $1}')
		HEIGHT=$(echo "$RES" | awk '{print $2}')
	fi
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

[ -n "$WIDTH" ] && [ -n "$HEIGHT" ] && ARGS=("/w:$WIDTH" "/h:$HEIGHT" "${ARGS[@]}")

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

# 131 = hyprland kill
OK_CODES=(0 1 131)

IS_OK=0
for code in "${OK_CODES[@]}"; do
	if [ "$EXIT_CODE" -eq "$code" ]; then
		IS_OK=1
		break
	fi
done

if [ "$IS_OK" -eq 0 ]; then
	if command -v notify-send >/dev/null; then
		notify-send -u critical "FreeRDP Error" "Connection failed for $RDP_HOST (Exit: $EXIT_CODE)"
	fi
	exit $EXIT_CODE
fi
