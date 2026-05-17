#!/usr/bin/env bash
# Weekly upstream-version check. Notifies via notify-send if a newer tag exists.
set -euo pipefail

cd ~/kam-dotfiles

git fetch upstream --tags --quiet

latest_upstream=$(git describe --tags --abbrev=0 upstream/main 2>/dev/null || echo "unknown")
on_base=$(cat kam/UPSTREAM_BASE 2>/dev/null || echo "unknown")

if [[ "$latest_upstream" != "$on_base" && "$latest_upstream" != "unknown" ]]; then
  notify-send -u normal -a "kam-dotfiles" \
    "Caelestia $latest_upstream available" \
    "You're on $on_base. Run: ~/kam-dotfiles/kam/upgrade.sh $latest_upstream"
fi
