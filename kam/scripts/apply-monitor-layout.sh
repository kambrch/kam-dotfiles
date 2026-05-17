#!/usr/bin/env bash

# Apply a sane monitor layout for currently detected outputs.
# - If both HDMI-A-1 and eDP-1 are present, keep HDMI left of eDP.
# - Otherwise, apply a safe per-output fallback.

set -u

if ! command -v hyprctl >/dev/null 2>&1; then
  exit 0
fi

mapfile -t monitors < <(hyprctl monitors all 2>/dev/null | awk '/^Monitor / {print $2}')

if [ "${#monitors[@]}" -eq 0 ]; then
  exit 0
fi

has() {
  local needle="$1"
  local m
  for m in "${monitors[@]}"; do
    if [ "$m" = "$needle" ]; then
      return 0
    fi
  done
  return 1
}

if has "HDMI-A-1" && has "eDP-1"; then
  hyprctl keyword monitor "HDMI-A-1,preferred,auto-left,1" >/dev/null 2>&1
  hyprctl keyword monitor "eDP-1,preferred,auto,1" >/dev/null 2>&1
  exit 0
fi

for mon in "${monitors[@]}"; do
  hyprctl keyword monitor "${mon},preferred,auto,1" >/dev/null 2>&1
done
