#!/usr/bin/env bash

SEPARATOR=" "
OPT_BT_ENABLE="󰂯  enable bluetooth"
OPT_BT_DISABLE="󰂲  disable bluetooth"
OPT_BT_SCAN_ENABLE="  scan"
OPT_BT_SCAN_DISABLE="  stop scanning"
OPT_BT_DEVICE_DISCOVERABLE_ENABLE="󰂳  make discoverable"
OPT_BT_DEVICE_DISCOVERABLE_DISABLE="󰂳  disable discoverable"
OPT_BT_DEVICE_PAIRABLE_ENABLE="󰂳  make pairable"
OPT_BT_DEVICE_PAIRABLE_DISABLE="󰂳  disable pairable"

generate_bt_list() {
  local menu_connected menu_disconnected
  menu_connected=""
  menu_disconnected=""

  while read -r MAC NAME; do
    [[ -z "$NAME" ]] && continue
    local connected=$(bluetoothctl info "$MAC" | awk '/Connected:/ {print $2}')
    local icon=""

    case $(bluetoothctl info "$MAC" | awk '/Icon:/ {print $2}') in
    audio) icon="󰋋" ;;
    keyboard) icon="󰌌" ;;
    mouse) icon="󰍽" ;;
    phone | phone-mobile) icon="" ;;
    *) icon="" ;;
    esac

    if [[ "$connected" == "yes" ]]; then
      menu_connected+="$icon  $NAME (connected)\n"
    else
      menu_disconnected+="$icon  $NAME\n"
    fi
  done <<<"$(bluetoothctl devices | awk '{print $2,$3}')"

  echo -e "$menu_connected$menu_disconnected"
}

show_rofi() {
  local menu=""
  menu+="$(generate_bt_list)\n-----\n"

  # adapter toggles
  menu+="$OPT_BT_DISABLE\n"
  [[ $(bluetoothctl show | awk '/Discovering:/ {print $2}') == "yes" ]] &&
    menu+="$OPT_BT_SCAN_DISABLE\n" || menu+="$OPT_BT_SCAN_ENABLE\n"
  [[ $(bluetoothctl show | awk '/Discoverable:/ {print $2}') == "yes" ]] &&
    menu+="$OPT_BT_DEVICE_DISCOVERABLE_DISABLE\n" || menu+="$OPT_BT_DEVICE_DISCOVERABLE_ENABLE\n"
  [[ $(bluetoothctl show | awk '/Pairable:/ {print $2}') == "yes" ]] &&
    menu+="$OPT_BT_DEVICE_PAIRABLE_DISABLE\n" || menu+="$OPT_BT_DEVICE_PAIRABLE_ENABLE\n"

  CHOICE=$(echo -e "$menu" | rofi -dmenu -i -p "bluetooth:")

  [[ -z "$CHOICE" ]] && return

  # handle adapter toggles (expand to devices later)
  case "$CHOICE" in
  "$OPT_BT_DISABLE") bluetoothctl power off ;;
  "$OPT_BT_SCAN_ENABLE") bluetoothctl scan on ;;
  "$OPT_BT_SCAN_DISABLE") bluetoothctl scan off ;;
  "$OPT_BT_DEVICE_DISCOVERABLE_ENABLE") bluetoothctl discoverable on ;;
  "$OPT_BT_DEVICE_DISCOVERABLE_DISABLE") bluetoothctl discoverable off ;;
  "$OPT_BT_DEVICE_PAIRABLE_ENABLE") bluetoothctl pairable on ;;
  "$OPT_BT_DEVICE_PAIRABLE_DISABLE") bluetoothctl pairable off ;;
  esac
}

show_rofi_enable_bluetooth() {
  CHOICE=$(echo -e "$OPT_BT_ENABLE" | rofi -dmenu -i -p "bluetooth:")
  [[ "$CHOICE" != "$OPT_BT_ENABLE" ]] && return
  bluetoothctl power on
}

if [[ $(bluetoothctl show | awk '/Powered:/ {print $2}') == "yes" ]]; then
  show_rofi
else
  show_rofi_enable_bluetooth
fi
