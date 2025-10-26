#!/usr/bin/env bash

# Notification levels
LEVELS=(20 15 10 5 4 3 2 1)
CHECK_INTERVAL=60 # in seconds

# Optional testing: set TEST_BATTERY_LEVEL to simulate a level
: "${TEST_BATTERY_LEVEL:=}"

LAST_LEVEL_NOTIFIED=""
LAST_STATUS=""

notify_status_change() {
  local status="$1"
  if [ "$status" = "Charging" ]; then
    notify-send -u normal "Power" "Charger plugged in"
  else
    notify-send -u normal "Power" "Charger unplugged"
  fi
}

while true; do
  # Get battery info
  if [ -n "$TEST_BATTERY_LEVEL" ]; then
    level=$TEST_BATTERY_LEVEL
    status="Discharging"
  else
    level=$(cat /sys/class/power_supply/BAT0/capacity)
    status=$(cat /sys/class/power_supply/BAT0/status)
  fi

  # Notify on status change
  if [ "$status" != "$LAST_STATUS" ]; then
    notify_status_change "$status"
    LAST_STATUS="$status"
    # Reset last battery notification if charger plugged in
    if [ "$status" = "Charging" ]; then
      LAST_LEVEL_NOTIFIED=""
    fi
  fi

  # Notify on low battery
  if [ "$status" = "Discharging" ]; then
    for trigger in "${LEVELS[@]}"; do
      if [ "$level" -eq "$trigger" ] && [ "$LAST_LEVEL_NOTIFIED" != "$trigger" ]; then
        notify-send -u critical "Low Battery" "${level}% remaining"
        LAST_LEVEL_NOTIFIED=$trigger
        break
      fi
    done
  fi

  sleep "$CHECK_INTERVAL"
done
