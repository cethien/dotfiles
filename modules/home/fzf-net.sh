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

if [ -n "$HAS_TAILSCALE" ]; then
  TS_STATUS=$(tailscale status --json 2>/dev/null | jq -r '.BackendState' 2>/dev/null) || TS_STATUS=""
  if [ "$TS_STATUS" = "NeedsLogin" ]; then
    add_opt "󰍂 login to tailscale" "sudo tailscale login" "silent"
  elif [ "$TS_STATUS" = "Running" ]; then
    add_opt "󰌙 disable tailscale" "tailscale down" "silent"
  else
    add_opt "󰌘 enable tailscale" "tailscale up --accept-routes" "silent"
  fi
fi

if [ -n "$HAS_WIFI" ]; then
  if nmcli radio wifi | grep -q "enabled"; then
    WIFI_INFO_CMD="nmcli device show | grep -E '(DEVICE|TYPE|IP4.ADDRESS|IP4.GATEWAY|IP4.DNS)' && echo '' && nmcli dev wifi show-password"
    add_opt "󰐲 wifi info" "$WIFI_INFO_CMD" "interactive"
    add_opt "󰖪 disable wifi" "nmcli radio wifi off" "silent"
  else
    add_opt "󰖩 enable wifi" "nmcli radio wifi on" "silent"
  fi
fi

add_opt "󰣖 network settings" "nmtui" "exec"

# 4. Quick Tools
command -v speedtest-go >/dev/null && add_opt "󰓅 speedtest" "speedtest-go" "interactive"
command -v net-scan >/dev/null && add_opt "󱚿 scan ports" "net-scan" "interactive"
command -v net-lookup >/dev/null && add_opt "󰬏 lookup domain" "net-lookup" "interactive"

CHOICE=$(printf "%s\n" "${MENU_ITEMS[@]}" | fzf --prompt="network > " --border)
[ -z "$CHOICE" ] && exit 0

CMD="${ACTIONS[$CHOICE]}"
TYPE="${ACTION_TYPES[$CHOICE]}"

case "$TYPE" in
"exec") exec $CMD ;;
"interactive")
  clear
  eval "$CMD"
  read -n 1 -s
  ;;
"silent") eval "$CMD" && notify-send "network" "$CHOICE" ;;
esac
