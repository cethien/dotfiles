#!/usr/bin/env bash

TITLE="󰖟 networking"
notify() { notify-send "$TITLE" "$1"; }

nmcli -t -f TYPE device | grep -q "wifi" && HAS_WIFI=1
nmcli -t -f TYPE,STATE device | grep -q "ethernet:connected" && HAS_ETH=1
ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1 && HAS_INTERNET=1

if [ -z "$HAS_WIFI" ] && [ -z "$HAS_ETH" ]; then
  notify "nothing to configure\nno wifi receiver or ethernet cable detected"
  exit 0
fi

if [ -n "$HAS_ETH" ] && [ -z "$HAS_INTERNET" ]; then
  notify "no internet access"
  exit 0
fi

SELECTED_SSID="$1"
ROFI_TITLE="$TITLE > "
MENU_OPTIONS=()

OPT_NET_CONNECT="󱘖  connect"
handle_net_connect() {
  nmcli connection up "$SELECTED_SSID" &&
    notify "connected to '$SELECTED_SSID'"
}

OPT_NET_DISCONNECT="  disconnect"
handle_net_disconnect() {
  nmcli connection down "$SELECTED_SSID" &&
    notify "disconnected from '$SELECTED_SSID'"
}

OPT_NET_AUTOCONNECT_ON="󰁪  enable autoconnect"
handle_net_autoconnect_on() {
  nmcli connection modify "$SELECTED_SSID" connection.autoconnect yes &&
    notify "'$SELECTED_SSID' autoconnect on"
}

OPT_NET_AUTOCONNECT_OFF="󱧧  disable autoconnect"
handle_net_autoconnect_off() {
  nmcli connection modify "$SELECTED_SSID" connection.autoconnect no &&
    notify "'$SELECTED_SSID' autoconnect off"
}

OPT_NET_FORGET="󰆴  forget network"
handle_net_forget() {
  nmcli connection delete "$SELECTED_SSID" &&
    notify "'$SELECTED_SSID' was deleted"
}

handle_new_open_connection() {
  nmcli device wifi connect "$SELECTED_SSID" &&
    notify "connected to open network '$SELECTED_SSID'"
}

handle_new_secure_connection() {
  PASSWORD=$(rofi -dmenu -p "Enter password for $SELECTED_SSID:" -password -theme-str 'listview {enabled: false;}')

  if [ -z "$PASSWORD" ]; then
    notify "Password is required to connect to '$SELECTED_SSID'"
    exit 1
  fi

  nmcli device wifi connect "$SELECTED_SSID" password "$PASSWORD" &&
    notify "connected to '$SELECTED_SSID'"
}

nmcli radio wifi | grep -q "enabled" && HAS_WIFI_ENABLED=1
WIFI_IFACE=$(nmcli -t -f DEVICE,TYPE device | grep ":wifi" | cut -d: -f1 | head -n1)

if [ -n "$SELECTED_SSID" ]; then
  ROFI_TITLE="󰖩  $SELECTED_SSID > "
  nmcli connection show "$SELECTED_SSID" >/dev/null 2>&1 && SAVED=1
  nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2}' | grep -Fxq "$SELECTED_SSID" && ACTIVE=1

  if [ -n "$SAVED" ]; then
    [ -n "$ACTIVE" ] &&
      MENU_OPTIONS+=("$OPT_NET_DISCONNECT") || MENU_OPTIONS+=("$OPT_NET_CONNECT")

    nmcli -f connection.autoconnect connection show "$SELECTED_SSID" | grep -q "yes" &&
      MENU_OPTIONS+=("$OPT_NET_AUTOCONNECT_OFF") || MENU_OPTIONS+=("$OPT_NET_AUTOCONNECT_ON")

    MENU_OPTIONS+=("$OPT_NET_FORGET")
  else
    nmcli -t -f SSID,SECURITY device wifi list ifname "$WIFI_IFACE" | grep -m 1 "$SELECTED_SSID" | cut -d: -f2 | grep -q . && SECURED=1
    if [ -n "$SECURED" ]; then
      handle_new_secure_connection
    else
      handle_new_open_connection
    fi
  fi
fi

OPT_SHOW_WIFI_INFO="  show wi-fi info"
handle_show_wifi_info() {
  local IFACE="$WIFI_IFACE"

  local IP GW
  IP=$(nmcli -t -f IP4.ADDRESS dev show "$IFACE" | head -n1 | cut -d: -f2)
  GW=$(nmcli -t -f IP4.GATEWAY dev show "$IFACE" | head -n1 | cut -d: -f2)

  local line SIGNAL FREQ RATE
  line=$(nmcli -t -f IN-USE,SIGNAL,FREQ,RATE dev wifi list ifname "$IFACE" | awk -F: '$1=="*"{print $0}')
  IFS=: read -r _ SIGNAL FREQ RATE <<<"$line"
  RATE="${RATE%% *}" # numeric only

  kitty -e bash -c "
nmcli dev wifi show
echo
echo 'ip: ${IP:-n/a}'
echo 'gateway: ${GW:-n/a}'
echo 'signal: ${SIGNAL:-n/a} %'
echo 'frequency: ${FREQ:-n/a}'
echo 'speed: ${RATE:-n/a} mb/s'
echo
read -n 1 -s -p 'press any key to close...'
"
}

OPT_WIFI_ENABLE="󰖩  enable wi-fi"
handle_wifi_enable() {
  nmcli radio wifi on && notify "wifi enabled"
}

OPT_WIFI_DISABLE="󰖪  disable wi-fi"
handle_wifi_disable() {
  nmcli radio wifi off && notify "wifi disabled"
}

if [ -z "$SELECTED_SSID" ] && [ -n "$HAS_WIFI" ]; then
  if [ -n "$HAS_WIFI_ENABLED" ]; then
    MENU_OPTIONS+=("$OPT_SHOW_WIFI_INFO")
    MENU_OPTIONS+=("$OPT_WIFI_DISABLE")
  else
    MENU_OPTIONS+=("$OPT_WIFI_ENABLE")
  fi
fi

command -v tailscale >/dev/null && HAS_TAILSCALE=1
if [ -n "$HAS_TAILSCALE" ]; then
  TS_JSON=$(tailscale status --json 2>/dev/null)

  if [ -n "$TS_JSON" ]; then
    TS_STATE=$(jq -r '.BackendState' <<<"$TS_JSON")
    [ "$TS_STATE" != "NeedsLogin" ] && IS_TAILSCALE_LOGGED_IN=1
    [ "$TS_STATE" = "Running" ] && IS_TAILSCALE_UP=1
  fi
fi

OPT_TAILSCALE_LOGIN="󰍂  tailscale login"
handle_tailscale_login() {
  local login_url
  login_url=$(tailscale login 2>&1 | grep -o 'https://login.tailscale.com[^ ]*')

  if [ -z "$login_url" ]; then
    notify "tailscale could not generate login link"
    return 1
  fi

  notify "opening tailscale login..."
  xdg-open "$login_url"

  (
    for i in {1..20}; do
      sleep 5
      if ! tailscale status | grep -q "Logged out"; then
        notify "tailscale successfully logged in"
        exit 0
      fi
    done
    notify "tailscale login timed out"
  ) &
}

OPT_TAILSCALE_ENABLE="󰌘  enable tailscale"
handle_tailscale_enable() {
  tailscale up && notify "tailscale enabled"
}

OPT_TAILSCALE_DISABLE="󰌙  disable tailscale"
handle_tailscale_disable() {
  tailscale down && notify "tailscale disabled"
}

if [ -z "$SELECTED_SSID" ] && [ -n "$HAS_TAILSCALE" ] && [ -n "$HAS_INTERNET" ]; then
  if [ -z "$IS_TAILSCALE_LOGGED_IN" ]; then
    MENU_OPTIONS+=("$OPT_TAILSCALE_LOGIN")
  elif [ -n "$IS_TAILSCALE_UP" ]; then
    MENU_OPTIONS+=("$OPT_TAILSCALE_DISABLE")
  else
    MENU_OPTIONS+=("$OPT_TAILSCALE_ENABLE")
  fi
fi

declare -A NETWORKS MENU_TO_SSID
SEPARATOR="------"
if [ -z "$SELECTED_SSID" ] && [ -n "$HAS_WIFI_ENABLED" ]; then
  MENU_OPTIONS+=("$SEPARATOR")

  ACTIVE_CONN=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | awk -F: '$2=="802-11-wireless"{print $1}')
  SAVED_CONNS=$(nmcli -t -f NAME connection show)

  SAVED_CONNS_ITEMS=()
  UNSAVED_CONNS_ITEMS=()
  UNSAVED_OPEN_CONNS_ITEMS=()
  ACTIVE_CONN_ITEM=""

  while IFS=: read -r SIGNAL SSID SECURITY; do
    [ -z "$SSID" ] && continue
    [ -n "${NETWORKS[$SSID]}" ] && continue

    NETWORKS["$SSID"]="$SECURITY"

    if [ "$SSID" = "$ACTIVE_CONN" ]; then
      if ((SIGNAL >= 75)); then
        ICON="󰤟"
      elif ((SIGNAL >= 50)); then
        ICON="󰤢"
      elif ((SIGNAL >= 25)); then
        ICON="󰤥"
      else
        ICON="󰤨"
      fi

      ACTIVE_CONN_ITEM="$ICON  $SSID"
      MENU_TO_SSID["$ACTIVE_CONN_ITEM"]="$SSID"

    elif echo "$SAVED_CONNS" | grep -Fxq "$SSID"; then
      ITEM="󰸋  $SSID"
      SAVED_CONNS_ITEMS+=("$ITEM")
      MENU_TO_SSID["$ITEM"]="$SSID"

    else
      if [ -z "$SECURITY" ]; then
        ITEM="󱛃  $SSID"
        UNSAVED_OPEN_CONNS_ITEMS+=("$ITEM")
      else
        ITEM="󱚿  $SSID"
        UNSAVED_CONNS_ITEMS+=("$ITEM")
      fi
      MENU_TO_SSID["$ITEM"]="$SSID"
    fi

  done < <(nmcli -t -f SIGNAL,SSID,SECURITY device wifi list ifname "$WIFI_IFACE")

  IFS=$'\n'
  readarray -t SAVED_CONNS_ITEMS < <(printf "%s\n" "${SAVED_CONNS_ITEMS[@]}" | sort)
  readarray -t UNSAVED_OPEN_CONNS_ITEMS < <(printf "%s\n" "${UNSAVED_OPEN_CONNS_ITEMS[@]}" | sort)
  readarray -t UNSAVED_CONNS_ITEMS < <(printf "%s\n" "${UNSAVED_CONNS_ITEMS[@]}" | sort)
  unset IFS

  [ -n "$ACTIVE_CONN_ITEM" ] && MENU_OPTIONS+=("$ACTIVE_CONN_ITEM")
  MENU_OPTIONS+=("${SAVED_CONNS_ITEMS[@]}")
  MENU_OPTIONS+=("${UNSAVED_OPEN_CONNS_ITEMS[@]}")
  MENU_OPTIONS+=("${UNSAVED_CONNS_ITEMS[@]}")
fi

CHOSEN=$(printf "%s\n" "${MENU_OPTIONS[@]}" | rofi -dmenu -p "$ROFI_TITLE")
[ -z "$CHOSEN" ] &&
  exit 0

SELECTED_MENU_OPTION="${MENU_TO_SSID[$CHOSEN]}"
[ -n "$SELECTED_MENU_OPTION" ] &&
  exec "$0" "$SELECTED_MENU_OPTION"

case "$CHOSEN" in
"$OPT_SHOW_WIFI_INFO") handle_show_wifi_info ;;
"$OPT_WIFI_ENABLE") handle_wifi_enable ;;
"$OPT_WIFI_DISABLE") handle_wifi_disable ;;
"$OPT_TAILSCALE_LOGIN") handle_tailscale_login ;;
"$OPT_TAILSCALE_ENABLE") handle_tailscale_enable ;;
"$OPT_TAILSCALE_DISABLE") handle_tailscale_disable ;;
"$SEPARATOR") $0 ;;
"$OPT_NET_CONNECT") handle_net_connect "$MANAGED_SSID" ;;
"$OPT_NET_DISCONNECT") handle_net_disconnect "$MANAGED_SSID" ;;
"$OPT_NET_AUTOCONNECT_ON") handle_net_autoconnect_on "$MANAGED_SSID" ;;
"$OPT_NET_AUTOCONNECT_OFF") handle_net_autoconnect_off "$MANAGED_SSID" ;;
"$OPT_NET_FORGET") handle_net_forget "$MANAGED_SSID" ;;
*) echo "unknow option selected" && exit 1 ;;

esac
