#!/usr/bin/env bash

# ==========================================
# CONFIGURATION VARIABLES
# ==========================================
# Battery Capacity Thresholds (%)
THRESHOLD_LOW=20
THRESHOLD_VERY_LOW=10
THRESHOLD_CRIT=5

# Notification Titles
TITLE_CONNECTED="Power Connected"
TITLE_DISCONNECTED="Power Disconnected"
TITLE_LOW="Battery Low"
TITLE_VERY_LOW="Battery Very Low"
TITLE_CRIT="Battery Critical"

# Notification Messages (printf templates)
MSG_CONNECTED="Charger Connected ⚡"
MSG_DISCONNECTED="Charger Disconnected ⚠️"
MSG_LOW="Battery is at %s%%."
MSG_VERY_LOW="Battery is at %s%%. Plug in your charger immediately!"
MSG_CRIT="Battery has dropped to %s%%! Shutting down soon!"

# Volatile State Cache File Location
STATE_FILE="/run/user/${UID}/battery-checker.state"

# ==========================================
# SYSTEM & HARDWARE CHECKS
# ==========================================
# Hardware Guard: Exit silently on desktops without a battery
if [ ! -d /sys/class/power_supply/BAT0 ]; then
  exit 0
fi

# Read current physical hardware states
CURRENT_STATUS=$(cat /sys/class/power_supply/BAT0/status)
CURRENT_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)

# Load the previous state if it exists, otherwise initialize tracking states
if [ -f "$STATE_FILE" ]; then
  # shellcheck source=/dev/null
  source "$STATE_FILE"
else
  LAST_STATUS=""
  LOW_NOTIFIED=0
  VERY_LOW_NOTIFIED=0
  CRIT_NOTIFIED=0
fi

STATE_CHANGED=0

# ==========================================
# CHARGER TRANSITION LOGIC
# ==========================================
if [ "$CURRENT_STATUS" != "$LAST_STATUS" ] && [ -n "$LAST_STATUS" ]; then
  if [ "$CURRENT_STATUS" = "Charging" ]; then
    notify-send -a "System" -i "battery-charging" "$TITLE_CONNECTED" "$MSG_CONNECTED"
  elif [ "$CURRENT_STATUS" = "Discharging" ]; then
    notify-send -a "System" -i "battery-warning" "$TITLE_DISCONNECTED" "$MSG_DISCONNECTED"
  fi
  LAST_STATUS="$CURRENT_STATUS"
  STATE_CHANGED=1
elif [ -z "$LAST_STATUS" ]; then
  LAST_STATUS="$CURRENT_STATUS"
  STATE_CHANGED=1
fi

# ==========================================
# BATTERY THRESHOLD LOGIC
# ==========================================
if [ "$CURRENT_STATUS" = "Discharging" ]; then
  # Tier 3: Critical
  if [ "$CURRENT_CAPACITY" -le "$THRESHOLD_CRIT" ] && [ "$CRIT_NOTIFIED" -eq 0 ]; then
    printf -v msg "$MSG_CRIT" "$CURRENT_CAPACITY"
    notify-send -u critical -a "System" "$TITLE_CRIT" "$msg"
    CRIT_NOTIFIED=1
    STATE_CHANGED=1

  # Tier 2: Very Low
  elif [ "$CURRENT_CAPACITY" -le "$THRESHOLD_VERY_LOW" ] && [ "$CURRENT_CAPACITY" -gt "$THRESHOLD_CRIT" ] && [ "$VERY_LOW_NOTIFIED" -eq 0 ]; then
    printf -v msg "$MSG_VERY_LOW" "$CURRENT_CAPACITY"
    notify-send -u critical -a "System" "$TITLE_VERY_LOW" "$msg"
    VERY_LOW_NOTIFIED=1
    STATE_CHANGED=1

  # Tier 1: Low
  elif [ "$CURRENT_CAPACITY" -le "$THRESHOLD_LOW" ] && [ "$CURRENT_CAPACITY" -gt "$THRESHOLD_VERY_LOW" ] && [ "$LOW_NOTIFIED" -eq 0 ]; then
    printf -v msg "$MSG_LOW" "$CURRENT_CAPACITY"
    notify-send -u normal -a "System" "$TITLE_LOW" "$msg"
    LOW_NOTIFIED=1
    STATE_CHANGED=1
  fi

# Reset all notifications instantly when charger is connected
elif [ "$CURRENT_STATUS" = "Charging" ]; then
  if [ "$LOW_NOTIFIED" -eq 1 ] || [ "$VERY_LOW_NOTIFIED" -eq 1 ] || [ "$CRIT_NOTIFIED" -eq 1 ]; then
    LOW_NOTIFIED=0
    VERY_LOW_NOTIFIED=0
    CRIT_NOTIFIED=0
    STATE_CHANGED=1
  fi
fi

# ==========================================
# SAVE LOGICAL STATES
# ==========================================
if [ "$STATE_CHANGED" -eq 1 ]; then
  {
    echo "LAST_STATUS=\"$CURRENT_STATUS\""
    echo "LOW_NOTIFIED=$LOW_NOTIFIED"
    echo "VERY_LOW_NOTIFIED=$VERY_LOW_NOTIFIED"
    echo "CRIT_NOTIFIED=$CRIT_NOTIFIED"
  } >"$STATE_FILE"
fi
