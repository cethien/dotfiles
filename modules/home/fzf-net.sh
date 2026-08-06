#!/usr/bin/env bash

# Hilfsfunktion für QR Scan (vermeidet klobige Strings & ShellCheck-Warnungen)
connect_via_qr() {
	local data ssid pass
	data=$(zbarcam -1 --raw /dev/video0 2>/dev/null)
	[ -z "$data" ] && return 1

	ssid=$(echo "$data" | sed -n 's/.*S:\([^;]*\).*/\1/p')
	pass=$(echo "$data" | sed -n 's/.*P:\([^;]*\).*/\1/p')

	if [ -n "$ssid" ]; then
		nmcli dev wifi connect "$ssid" password "$pass"
	fi
}

# Exportieren, falls interaktiv aus Subshell aufgerufen
export -f connect_via_qr

HAS_WIFI_DEV=$(nmcli -t -f TYPE device 2>/dev/null | grep -q "^wifi" && echo "1")
WIFI_ENABLED=$(nmcli radio wifi 2>/dev/null | grep -q "^enabled" && echo "1")

IS_CONNECTED=""
if ip route get 1.1.1.1 >/dev/null 2>&1; then
	IS_CONNECTED="1"
fi

# 1. Kein Netz + WiFi aus/geblockt oder nicht vorhanden -> Direkt Impala
if [ -z "$IS_CONNECTED" ]; then
	if [ -z "$HAS_WIFI_DEV" ] || [ -z "$WIFI_ENABLED" ]; then
		exec impala
	fi
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

# 2. Statusbasierte Menüpunkte
if [ -n "$IS_CONNECTED" ]; then
	# Verbunden: LAN oder WLAN
	add_opt "󰣖 network settings" "impala" "exec"

	if command -v tailscale >/dev/null; then
		TS_STATUS=$(tailscale status --json 2>/dev/null | jq -r '.BackendState' 2>/dev/null)
		case "$TS_STATUS" in
		"NeedsLogin") add_opt "󰍂 login to tailscale" "sudo tailscale login" "silent" ;;
		"Running") add_opt "󰌙 disable tailscale" "tailscale down" "silent" ;;
		"Stopped") add_opt "󰌘 enable tailscale" "tailscale up --accept-routes" "silent" ;;
		esac
	fi
else
	# Nicht verbunden: QR-Option NUR anzeigen, wenn WLAN-Hardware da & eingeschaltet ist
	if [ -n "$HAS_WIFI_DEV" ] && [ -n "$WIFI_ENABLED" ]; then
		add_opt "󰄀 connect via qr" "connect_via_qr" "interactive"
	fi
	add_opt "󰣖 network settings" "impala" "exec"
fi

[ ${#MENU_ITEMS[@]} -eq 0 ] && exit 0

# Preview Setup
ACTIVE_DEV=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'dev \K\S+')
CONN_NAME=""
[ -n "$ACTIVE_DEV" ] && CONN_NAME=$(nmcli -t -f GENERAL.CONNECTION dev show "$ACTIVE_DEV" 2>/dev/null | cut -d: -f2)

PREVIEW_OPTS=()
if [ -n "$CONN_NAME" ]; then
	PREVIEW_OPTS=(
		--preview="netz-preview"
		--preview-window="right:60%:wrap"
		--preview-label=" $CONN_NAME "
	)
else
	PREVIEW_OPTS=(--preview-window="hidden")
fi

CHOICE=$(printf "%s\n" "${MENU_ITEMS[@]}" | fzf --prompt="network > " "${PREVIEW_OPTS[@]}")
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
	read -n 1 -s -r -p "Press any key to continue..."
	;;
"silent")
	eval "$CMD" && notify-send "network" "$CHOICE"
	;;
esac
