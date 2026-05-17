#!/usr/bin/env bash

# Print a short warning only when Caps Lock is enabled.
state="$(cat /sys/class/leds/input*::capslock/brightness 2>/dev/null | head -n1)"
if [ "${state:-0}" = "1" ]; then
  printf 'Caps Lock is ON'
fi
