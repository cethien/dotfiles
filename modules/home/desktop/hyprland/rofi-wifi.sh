#!/usr/bin/env bash

# ===== CONFIG =====
HOTSPOT_SSID="$(hostname)"
HOTSPOT_CONN_NAME="${HOTSPOT_SSID}_hotspot"
WIFI_IFACE=$(nmcli device status | awk '/wifi/ {print $1; exit}')
SEPARATOR="-----"

# ===== OPTIONS =====
OPT_SHOW_WIFI_INFO="  show wi-fi info"
OPT_WIFI_ENABLE="󰖩  enable wi-fi"
OPT_WIFI_DISABLE="󰖪  disable wi-fi"

# ===== HELPERS =====
show_wifi_info() {
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
echo 'frequency: ${FREQ:-n/a} mhz'
echo 'speed: ${RATE:-n/a} mb/s'
echo
read -n 1 -s -p 'press any key to close...'
"
}

wifi_enable() {
  nmcli radio wifi on && notify-send "󰖩 wifi enabled"
}

wifi_disable() {
  nmcli radio wifi off && notify-send "󰖪 wifi disabled"
}

# ===== GENERATE WIFI MENU =====
generate_wifi_list() {
  local current saved
  current=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2}')
  saved=$(nmcli -t -f NAME connection show)

  local menu_connected=()
  local menu_saved=()
  local menu_new=()

  while IFS=: read -r SIGNAL SSID SECURITY; do
    [[ -z "$SSID" ]] && continue
    local icon

    if [[ "$SSID" == "$current" ]]; then
      # Connected icons
      if ((SIGNAL >= 75)); then
        icon="󰤟"
      elif ((SIGNAL >= 50)); then
        icon="󰤢"
      elif ((SIGNAL >= 25)); then
        icon="󰤥"
      else
        icon="󰤨"
      fi
      menu_connected+=("$icon  $SSID")
    elif echo "$saved" | grep -qx "$SSID"; then
      icon="󰸋"
      menu_saved+=("$icon  $SSID")
    else
      [[ "$SECURITY" == "--" ]] && icon="" || icon=""
      menu_new+=("$icon  $SSID")
    fi
  done < <(nmcli -t -f SIGNAL,SSID,SECURITY device wifi list ifname "$WIFI_IFACE")

  WIFI_DISPLAY_MENU=("${menu_connected[@]}" "${menu_saved[@]}" "${menu_new[@]}")
  WIFI_PLAIN_MENU=()
  for item in "${WIFI_DISPLAY_MENU[@]}"; do
    WIFI_PLAIN_MENU+=("${item:3}") # strip icon + space
  done
}

# ===== HANDLE CONNECTIONS =====
handle_saved_connection() {
  local SSID="$1"
  local current ac_status choice

  while true; do
    current=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2}')
    [[ "$SSID" == "$current" ]] && opt_connect_disconnect="  disconnect" || opt_connect_disconnect="󱘖  connect"
    ac_status=$(nmcli -g connection.autoconnect connection show "$SSID")
    [[ "$ac_status" == "yes" ]] && opt_autoconnect="󰑗  disable autoconnect" || opt_autoconnect="󰑖  enable autoconnect"
    opt_delete="󰆴  forget"

    choice=$(printf "%s\n%s\n%s\n" "$opt_connect_disconnect" "$opt_autoconnect" "$opt_delete" |
      rofi -dmenu -i -p "$SSID") || break

    case "$choice" in
    "  disconnect") nmcli connection down "$SSID" && notify-send " disconnected to wifi" "$SSID" ;;
    "󱘖  connect") nmcli connection up id "$SSID" && notify-send "󱘖 connected to wifi" "$SSID" ;;
    "󰑖  enable autoconnect") nmcli connection modify "$SSID" connection.autoconnect yes ;;
    "󰑗  disable autoconnect") nmcli connection modify "$SSID" connection.autoconnect no ;;
    "󰆴  forget")
      nmcli connection delete "$SSID"
      notify-send "󰆴 wifi network removed" "$SSID"
      break
      ;;
    esac
  done
}

handle_new_connection() {
  local SSID="$1"
  local pwd
  local from_secret=0
  local store_choice

  # Try to get password from secret-tool (KeePassXC Secret Service)
  if pwd=$(secret-tool lookup ssid "$SSID" 2>/dev/null); then
    from_secret=1
  else
    pwd=""
  fi

  while true; do
    # Prompt if no password yet
    if [[ -z "$pwd" ]]; then
      pwd=$(rofi -dmenu -password -p "$SSID password:" 2>/dev/null) || return
      [[ -z "$pwd" ]] && return
      from_secret=0
    fi

    # Try to connect with nmcli
    if nmcli device wifi connect "$SSID" password "$pwd"; then
      notify-send "󰤟 Wi-Fi connected" "$SSID"

      # Offer to store password if it was entered manually
      if [[ $from_secret -eq 0 ]]; then
        store_choice=$(printf "Yes\nNo" | rofi -dmenu -p "Store password for $SSID?" 2>/dev/null)
        if [[ $store_choice == "Yes" ]]; then
          echo -n "$pwd" | secret-tool store --label="$SSID" ssid "$SSID" UserName ""
          notify-send "󰍡 Wi-Fi password stored" "$SSID"
        fi
      fi
      return 0
    else
      notify-send "󰤨 Wi-Fi connection failed" "$SSID"
      pwd="" # clear so we re-prompt
    fi
  done
}

handle_connection() {
  local SSID="$1"
  if nmcli -t -f NAME connection show | grep -qx "$SSID"; then
    handle_saved_connection "$SSID"
  else
    handle_new_connection "$SSID"
  fi
}

# ===== MAIN MENU =====
main() {
  MENU=()

  CONNECTED_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2}')
  WIFI_STATUS=$(nmcli radio wifi)

  [[ -n "$CONNECTED_SSID" ]] && MENU+=("$OPT_SHOW_WIFI_INFO")

  if [[ "$WIFI_STATUS" == "disabled" ]]; then
    MENU+=("$OPT_WIFI_ENABLE")
  else
    MENU+=("$OPT_WIFI_DISABLE")
  fi

  if [[ "$WIFI_STATUS" == "enabled" ]]; then
    MENU+=("$SEPARATOR")
    generate_wifi_list
    MENU+=("${WIFI_DISPLAY_MENU[@]}")
  fi

  local CHOICE
  CHOICE=$(printf "%s\n" "${MENU[@]}" | rofi -dmenu -i -p "wifi menu") || exit

  case "$CHOICE" in
  "$OPT_SHOW_WIFI_INFO") show_wifi_info ;;
  "$OPT_WIFI_ENABLE") wifi_enable ;;
  "$OPT_WIFI_DISABLE") wifi_disable ;;
  "$SEPARATOR") ;; # do nothing
  *) handle_connection "${WIFI_PLAIN_MENU[$(($(printf "%s\n" "${WIFI_DISPLAY_MENU[@]}" | grep -nx "$CHOICE" | cut -d: -f1) - 1))]}" ;;
  esac
}

main
