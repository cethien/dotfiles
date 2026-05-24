#!/usr/bin/env bash

command -v tailscale >/dev/null && HAS_TAILSCALE=1 || HAS_TAILSCALE=""
nmcli -t -f TYPE device | grep -q "wifi" && HAS_WIFI=1 || HAS_WIFI=""

declare -A ACTIONS
declare -A ACTION_TYPES
MENU_ITEMS=()

add_opt() {
  local label="$1" script="$2" type="$3"
  MENU_ITEMS+=("$label")
  ACTIONS["$label"]="$script"
  ACTION_TYPES["$label"]="$type"
}

if [ -n "$HAS_WIFI" ]; then
  if nmcli radio wifi | grep -q "enabled"; then
    WIFI_INFO_CMD="nmcli device show | grep -E '(DEVICE|TYPE|IP4.ADDRESS|IP4.GATEWAY|IP4.DNS)' && echo '' && nmcli dev wifi show-password"
    add_opt "󰄛  Wi-Fi Connection Details & QR" "$WIFI_INFO_CMD" "interactive"
    add_opt "󰖪  Disable Wi-Fi" "nmcli radio wifi off" "silent"
  else
    add_opt "󰖩  Enable Wi-Fi" "nmcli radio wifi on" "silent"
  fi
fi
add_opt "󰖩  manage network" "nmtui" "exec"

if [ -n "$HAS_TAILSCALE" ]; then
  TS_STATUS=$(tailscale status --json 2>/dev/null | jq -r '.BackendState' 2>/dev/null) || TS_STATUS=""
  if [ "$TS_STATUS" = "Running" ]; then
    add_opt "󰌙  Tailscale: Disable" "tailscale down" "silent"
  elif [ "$TS_STATUS" = "NeedsLogin" ]; then
    add_opt "󰍂  Tailscale: Login" "tailscale login" "silent"
  else
    add_opt "󰌘  Tailscale: Enable" "tailscale up --accept-routes" "silent"
  fi
fi

# 4. Quick Tools
command -v speedtest-go >/dev/null && add_opt "󰓅  speedtest" "speedtest-go" "interactive"
command -v net-scan >/dev/null && add_opt "󱚿  portscan" "net-scan" "interactive"
command -v net-lookup >/dev/null && add_opt "󰬏  domain lookup" "net-lookup" "interactive"

CHOICE=$(printf "%s\n" "${MENU_ITEMS[@]}" | fzf --prompt="Quick Net > " --height=40% --border)
[ -z "$CHOICE" ] && exit 0

CMD="${ACTIONS[$CHOICE]}"
TYPE="${ACTION_TYPES[$CHOICE]}"

case "$TYPE" in
"exec") exec $CMD ;;
"interactive")
  clear
  eval "$CMD"
  echo -e "\nDone - Press any key to exit"
  read -n 1 -s
  ;;
"silent") eval "$CMD" && notify-send "Network" "$CHOICE executed" ;;
esac
