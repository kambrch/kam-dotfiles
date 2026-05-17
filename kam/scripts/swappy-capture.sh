#!/usr/bin/env bash
set -euo pipefail

mode="${1:-region}"
# Working files live in runtime tmp so captures do not clutter home directories.
tmp_dir="${XDG_RUNTIME_DIR:-/tmp}/hypr-swappy"
mkdir -p "$tmp_dir"
infile="$tmp_dir/capture_$(date '+%Y-%m-%d_%H-%M-%S').png"
outfile="$tmp_dir/annotated_$(date '+%Y-%m-%d_%H-%M-%S').png"

notify() {
  command -v notify-send >/dev/null 2>&1 && notify-send "Screenshot" "$1" -a "Hyprland" || true
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    notify "Missing dependency: $1"
    exit 1
  }
}

require_cmd grim
require_cmd swappy

case "$mode" in
  region)
    require_cmd slurp
    # 1) Select region interactively.
    geometry="$(slurp -d 2>/dev/null || true)"
    [ -n "$geometry" ] || exit 0
    # 2) Capture the selected region to a temporary input image.
    grim -g "$geometry" "$infile"
    ;;
  full)
    # 1) Capture the whole active output to a temporary input image.
    grim "$infile"
    ;;
  *)
    notify "Unknown mode '$mode' (expected: region|full)."
    exit 2
    ;;
esac

# 3) Open capture in swappy for annotation and save edited result on exit.
swappy -f "$infile" -o "$outfile"

# 4) Copy annotated result to clipboard for quick paste into chat/docs.
if [ -s "$outfile" ] && command -v wl-copy >/dev/null 2>&1; then
  wl-copy < "$outfile" || true
fi
