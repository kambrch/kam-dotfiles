#!/usr/bin/env bash

# Keep it lightweight and failure-safe for lock screen updates.
batt_path="/sys/class/power_supply/BAT0/capacity"
if [ -r "$batt_path" ]; then
  batt="$(cat "$batt_path" 2>/dev/null)"
  printf 'Battery: %s%%' "${batt:-n/a}"
else
  printf 'Locked'
fi
