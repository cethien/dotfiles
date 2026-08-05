#!/usr/bin/env bash

command -v tailscale >/dev/null && HAS_TAILSCALE=1 || HAS_TAILSCALE=""
command -v impala >/dev/null && TUI_CMD="impala" || TUI_CMD="nmtui"

HAS_WIFI_DEV=$(nmcli -t -f TYPE device | grep -q "wifi" && echo "1" || echo "")
WIFI_ENABLED=$(nmcli radio wifi | grep -q "enabled" && echo "1" || echo "")

CONNECTED_WIFI=$(nmcli -t -f TYPE,STATE device | grep -q "^wifi:connected" && echo "1" || echo "")
CONNECTED_ETH=$(nmcli -t -f TYPE,STATE device | grep -q "^ethernet:connected" && echo "1" || echo "")
HAS_DEFAULT_ROUTE=$(ip route | grep -q "^default" && echo "1" || echo "")

IS_ONLINE=""
IS_LOCAL_LAN=""
IS_DISCONNECTED=""

if [ -n "$HAS_DEFAULT_ROUTE" ]; then
	IS_ONLINE=1
elif [ -n "$CONNECTED_ETH" ] || [ -n "$CONNECTED_WIFI" ]; then
	IS_LOCAL_LAN=1
else
	IS_DISCONNECTED=1
fi

declare -A ACTIONS
declare -A ACTION_TYPES
MENU_ITEMS=()

add_opt() {
	local label="$1" script="$2" type="$3"
	MENU_ITEMS+=("$label")
	ACTIONS["$label"]="$script"
	ACTION_TYPES["$label"]="$type"
}

# --- STATE 1: COMPLETELY DISCONNECTED ---
if [ -n "$IS_DISCONNECTED" ]; then
	if [ -n "$HAS_WIFI_DEV" ] && [ -z "$WIFI_ENABLED" ]; then
		add_opt "󰖩 enable wifi" "nmcli radio wifi on" "silent"
	fi
	add_opt "󰣖 network settings" "$TUI_CMD" "exec"

# --- STATE 2: WIFI AN, ABER NICHT VERBUNDEN ---
elif [ -n "$HAS_WIFI_DEV" ] && [ -n "$WIFI_ENABLED" ] && [ -z "$CONNECTED_WIFI" ] && [ -z "$CONNECTED_ETH" ]; then
	if command -v zbarcam >/dev/null; then
		QR_CONNECT_CMD='DATA=$(zbarcam -1 --raw /dev/video0); SSID=$(echo "$DATA" | sed -n "s/.*S:\([^;]*\).*/\1/p"); PASS=$(echo "$DATA" | sed -n "s/.*P:\([^;]*\).*/\1/p"); nmcli dev wifi connect "$SSID" password "$PASS"'
		add_opt "󰄀 connect via qr" "$QR_CONNECT_CMD" "interactive"
	fi
	add_opt "󰣖 network settings" "$TUI_CMD" "exec"

# --- STATE 3: LOCAL LAN ONLY ---
elif [ -n "$IS_LOCAL_LAN" ] && [ -z "$IS_ONLINE" ]; then
	add_opt "󰣖 network settings" "$TUI_CMD" "exec"

# --- STATE 4: FULL WAN ONLINE ---
elif [ -n "$IS_ONLINE" ]; then
	if [ -n "$HAS_TAILSCALE" ]; then
		TS_STATUS=$(tailscale status --json 2>/dev/null | jq -r '.BackendState' 2>/dev/null) || TS_STATUS=""
		if [ "$TS_STATUS" = "NeedsLogin" ]; then
			add_opt "󰍂 login to tailscale" "sudo tailscale login" "silent"
		elif [ "$TS_STATUS" = "Running" ]; then
			add_opt "󰌙 disable tailscale" "tailscale down" "silent"
		elif [ "$TS_STATUS" = "Stopped" ]; then
			add_opt "󰌘 enable tailscale" "tailscale up --accept-routes" "silent"
		fi
	fi

	add_opt "󰣖 network settings" "$TUI_CMD" "exec"
fi

[ ${#MENU_ITEMS[@]} -eq 0 ] && exit 0

ACTIVE_DEV=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'dev \K\S+')
CONN_NAME=""
[ -n "$ACTIVE_DEV" ] && CONN_NAME=$(nmcli -t -f GENERAL.CONNECTION dev show "$ACTIVE_DEV" 2>/dev/null | cut -d: -f2)

PREVIEW_OPTS=()
if [ -n "$CONN_NAME" ]; then
	PREVIEW_OPTS+=(
		--preview="netz-preview {}"
		--preview-window="right:60%:wrap"
		--preview-label=" $CONN_NAME "
	)
else
	PREVIEW_OPTS+=(--preview-window="hidden")
fi

CHOICE=$(printf "%s\n" "${MENU_ITEMS[@]}" | fzf \
	--prompt="network > " \
	"${PREVIEW_OPTS[@]}")

[ -z "$CHOICE" ] && exit 0

CMD="${ACTIONS[$CHOICE]}"
TYPE="${ACTION_TYPES[$CHOICE]}"

case "$TYPE" in
"exec")
	exec $CMD
	;;
"interactive")
	clear
	eval "$CMD"
	echo ""
	read -n 1 -s -r -p "Press any key to continue..."
	;;
"silent")
	eval "$CMD" && notify-send "network" "$CHOICE"
	;;
esac
