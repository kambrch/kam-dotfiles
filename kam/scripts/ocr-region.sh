#!/usr/bin/env bash
set -euo pipefail

notify() {
  command -v notify-send >/dev/null 2>&1 && notify-send "OCR" "$1" -a "Hyprland" || true
}

for cmd in grim slurp tesseract wl-copy; do
  command -v "$cmd" >/dev/null 2>&1 || {
    notify "Missing dependency: $cmd"
    exit 1
  }
done

geometry="$(slurp -d 2>/dev/null || true)"
[ -n "$geometry" ] || exit 0

# Capture selected area and OCR to stdout, then copy recognized text.
text="$(grim -g "$geometry" - | tesseract stdin stdout 2>/dev/null | sed 's/[[:space:]]*$//')"

if [ -z "$text" ]; then
  notify "No text recognized."
  exit 0
fi

printf '%s' "$text" | wl-copy
notify "Recognized text copied to clipboard."
