#!/usr/bin/env bash
# Track a new upstream tag: rebase + rebuild plugin + push.
# Usage: upgrade.sh <tag>   (e.g. ./upgrade.sh v1.6.3)
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <upstream-tag>" >&2
  exit 1
fi
TAG="$1"

cd ~/kam-dotfiles

echo "[upgrade] fetching upstream..."
git fetch upstream --tags

echo "[upgrade] checking out main..."
git checkout main

echo "[upgrade] rebasing onto upstream/$TAG..."
if ! git rebase "upstream/$TAG"; then
  echo "[upgrade] REBASE PAUSED. Resolve conflicts, then 'git rebase --continue' and re-run this script."
  exit 1
fi

echo "[upgrade] rebuilding plugin..."
cmake --build build --clean-first
cmake --install build

echo "[upgrade] bumping UPSTREAM_BASE..."
echo "$TAG" > kam/UPSTREAM_BASE
git add kam/UPSTREAM_BASE
git commit -m "kam: bump UPSTREAM_BASE to $TAG"

echo "[upgrade] pushing..."
git push --force-with-lease origin main

echo "[upgrade] restarting Quickshell..."
pkill quickshell || true
sleep 1
hyprctl dispatch exec caelestia-shell 2>/dev/null || echo "[upgrade] could not auto-restart; restart manually"

echo "[upgrade] done. On $TAG."
