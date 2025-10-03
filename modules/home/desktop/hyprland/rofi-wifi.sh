#!/usr/bin/env bash

HOTSPOT_SSID="$(hostname)"
HOTSPOT_PASSWORD="supersecret"

OPT_SHOW_WIFI="󰌄  show wi-fi info"
OPT_WIFI_ENABLE="󰖩  enable wi-fi"
OPT_WIFI_DISABLE="󰖪  disable wi-fi"
OPT_HOTSPOT_ENABLE="󰌘  enable hotspot"
OPT_HOTSPOT_DISABLE="󰌙  disable hotspot"

WIFI_IFACE=$(nmcli device status | awk '/wifi/ {print $1; exit}')

show_current_wifi_info() {
  kitty -e bash -c 'nmcli dev wifi show; read -n 1 -s -p "press any key to close..."'
}

generate_wifi_list() {
  local current=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2}')
  local saved=$(nmcli -t -f NAME connection show)
  local menu_connected menu_saved menu_new
  menu_connected=""
  menu_saved=""
  menu_new=""

  while IFS=: read -r SIGNAL SSID SECURITY; do
    [[ -z "$SSID" ]] && continue
    local icon=""
    if [[ "$SSID" == "$current" ]]; then
      if ((SIGNAL >= 75)); then
        icon="󰤟"
      elif ((SIGNAL >= 50)); then
        icon="󰤢"
      elif ((SIGNAL >= 25)); then
        icon="󰤥"
      else icon="󰤨"; fi
      menu_connected+="$icon  $SSID\n"
    elif echo "$saved" | grep -qx "$SSID"; then
      icon="󰸋"
      menu_saved+="$icon  $SSID\n"
    else
      [[ "$SECURITY" == "--" ]] && icon="" || icon=""
      menu_new+="$icon  $SSID\n"
    fi
  done <<<"$(nmcli -t -f SIGNAL,SSID,SECURITY device wifi list ifname "$WIFI_IFACE")"

  echo -e "$menu_connected$menu_saved$menu_new"
}

show_saved_network_menu() {
  local SSID="$1"
  local current=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2}')
  local menu=""

  if [[ "$SSID" == "$current" ]]; then
    menu="  disconnect"
  else
    menu="󱘖  connect\n󰆴  forget"
  fi

  local chosen=$(echo -e "$menu" | rofi -dmenu -i -p "$SSID")
  [[ -z "$chosen" ]] && return

  case "$chosen" in
  "  disconnect")
    nmcli connection down "$SSID" && notify-send "disconnected" "$SSID"
    ;;
  "󱘖  connect")
    nmcli connection up id "$SSID" | grep "successfully" && notify-send "connected" "$SSID"
    ;;
  "󰆴  forget")
    nmcli connection delete "$SSID" && notify-send "forgot network" "$SSID"
    ;;
  esac
}

show_wifi_rofi() {
  local wifi_status=$(nmcli -fields WIFI g)
  local menu=""

  [[ "$wifi_status" =~ "enabled" ]] && menu="$OPT_SHOW_WIFI\n"

  local toggle_wifi
  [[ "$wifi_status" =~ "enabled" ]] && toggle_wifi="$OPT_WIFI_DISABLE" || toggle_wifi="$OPT_WIFI_ENABLE"
  menu="$menu$toggle_wifi\n$OPT_HOTSPOT_ENABLE\n-----\n"

  [[ "$wifi_status" =~ "enabled" ]] && menu+=$(generate_wifi_list)

  local chosen=$(echo -e "$menu" | uniq -u | rofi -dmenu -i -p "wi-fi / hotspot: ")
  [[ -z "$chosen" ]] && return

  local chosen_id="${chosen:3}"
  local saved=$(nmcli -g NAME connection)

  case "$chosen" in
  "$OPT_WIFI_ENABLE") nmcli radio wifi on && notify-send "wifi enabled" ;;
  "$OPT_WIFI_DISABLE") nmcli radio wifi off && notify-send "wifi disabled" ;;
  "$OPT_HOTSPOT_ENABLE")
    nmcli dev wifi hotspot ifname "$WIFI_IFACE" ssid "$HOTSPOT_SSID" password "$HOTSPOT_PASSWORD"
    notify-send "hotspot enabled" "$HOTSPOT_SSID"
    ;;
  "$OPT_SHOW_WIFI") show_current_wifi_info ;;
  *)
    if echo "$saved" | grep -qx "$chosen_id"; then
      show_saved_network_menu "$chosen_id"
    else
      local wifi_password=""
      if [[ "$chosen" =~ "" ]]; then
        wifi_password=$(rofi -dmenu -p "password: ")
        [[ -z "$wifi_password" ]] && return
      fi
      nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "connection established" "$chosen_id"
    fi
    ;;
  esac
}

show_hotspot_rofi() {
  local connected_devices=$(iw dev "$WIFI_IFACE" station dump | awk '/Station/ {print $2}')
  local menu="$OPT_SHOW_WIFI\n$OPT_HOTSPOT_DISABLE"
  [[ -n "$connected_devices" ]] && menu="$menu\n-----\n$connected_devices"

  local chosen=$(echo -e "$menu" | rofi -dmenu -i -p "hotspot active: ")
  [[ -z "$chosen" ]] && return

  case "$chosen" in
  "$OPT_HOTSPOT_DISABLE")
    nmcli connection down Hotspot
    notify-send "hotspot disabled"
    ;;
  "$OPT_SHOW_WIFI") show_current_wifi_info ;;
  *)
    iw dev "$WIFI_IFACE" station del "$chosen"
    notify-send "device disconnected" "$chosen"
    ;;
  esac
}

if nmcli -t -f NAME connection show --active | grep -qw "Hotspot"; then
  show_hotspot_rofi
else
  show_wifi_rofi
fi
