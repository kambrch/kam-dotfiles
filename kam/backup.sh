#!/usr/bin/env bash
# Pre-migration archive of current ii setup. Run once before Phase D install.
set -euo pipefail

archive_dir="$HOME/.config/.archived-ii-$(date +%Y-%m-%d)"
mkdir -p "$archive_dir"

for d in quickshell illogical-impulse hypr matugen; do
  src="$HOME/.config/$d"
  if [[ -d "$src" ]]; then
    cp -r "$src" "$archive_dir/"
    echo "[backup] $src → $archive_dir/$d"
  else
    echo "[backup] $src missing — skipping"
  fi
done

# Capture any uncommitted drift in hypr custom/ git repo
if [[ -d "$HOME/.config/hypr/custom/.git" ]]; then
  (
    cd "$HOME/.config/hypr/custom"
    if ! git diff --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
      git stash push -u -m "pre-caelestia-migration $(date -Iseconds)"
      echo "[backup] hypr/custom drift stashed"
    else
      echo "[backup] hypr/custom clean — no stash needed"
    fi
  )
fi

echo "[backup] Archive size:"
du -sh "$archive_dir"
echo "[backup] Done. Archive: $archive_dir"
