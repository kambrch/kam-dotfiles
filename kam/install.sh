#!/usr/bin/env bash
# Idempotent installer for the kam Caelestia fork.
# Run from anywhere; resolves its own path.
set -euo pipefail

KAM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KAM_DIR="$KAM_ROOT/kam"

echo "[install] KAM_ROOT=$KAM_ROOT"

# --- 1. Ensure ~/.config/quickshell/caelestia is a symlink to the fork ---
QS_DIR="$HOME/.config/quickshell/caelestia"
mkdir -p "$(dirname "$QS_DIR")"
if [[ -L "$QS_DIR" ]]; then
  target=$(readlink -f "$QS_DIR")
  if [[ "$target" != "$KAM_ROOT" ]]; then
    echo "[install] WARN: $QS_DIR points at $target; replacing with $KAM_ROOT"
    rm "$QS_DIR"
    ln -s "$KAM_ROOT" "$QS_DIR"
  fi
elif [[ -e "$QS_DIR" ]]; then
  echo "[install] ERROR: $QS_DIR exists and is not a symlink. Aborting; move it aside first." >&2
  exit 1
else
  ln -s "$KAM_ROOT" "$QS_DIR"
fi
echo "[install] $QS_DIR → $KAM_ROOT"

# --- 2. Build + install plugin user-locally ---
cd "$KAM_ROOT"
cmake -B build \
  -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
  -DINSTALL_QMLDIR=lib/qt6/qml \
  -DINSTALL_QSCONFDIR=share/caelestia
cmake --build build
cmake --install build
echo "[install] Plugin installed under ~/.local/lib/qt6/qml/Caelestia/"

# --- 3. Symlink configs ---
CAE_CONF="$HOME/.config/caelestia"
mkdir -p "$CAE_CONF"
for f in hypr-user.conf hypr-vars.conf shell.json shell-tokens.json; do
  src="$KAM_DIR/configs/$f"
  dst="$CAE_CONF/$f"
  if [[ -L "$dst" || ! -e "$dst" ]]; then
    rm -f "$dst"
    ln -s "$src" "$dst"
    echo "[install] $dst → $src"
  else
    echo "[install] WARN: $dst exists and is not a symlink; skipping" >&2
  fi
done

# --- 4. Symlink hyprland scripts ---
HYPR_SCRIPTS="$HOME/.config/hypr/scripts"
if [[ -L "$HYPR_SCRIPTS" ]]; then
  rm "$HYPR_SCRIPTS"
fi
if [[ -d "$HYPR_SCRIPTS" && ! -L "$HYPR_SCRIPTS" ]]; then
  echo "[install] WARN: $HYPR_SCRIPTS is a real directory; backing up to ${HYPR_SCRIPTS}.bak"
  mv "$HYPR_SCRIPTS" "${HYPR_SCRIPTS}.bak"
fi
ln -s "$KAM_DIR/scripts" "$HYPR_SCRIPTS"
echo "[install] $HYPR_SCRIPTS → $KAM_DIR/scripts"

# --- 5. Symlink systemd user units ---
SYSD="$HOME/.config/systemd/user"
mkdir -p "$SYSD"
for unit in caelestia-upstream-check.service caelestia-upstream-check.timer; do
  src="$KAM_DIR/systemd/$unit"
  dst="$SYSD/$unit"
  rm -f "$dst"
  ln -s "$src" "$dst"
done
systemctl --user daemon-reload
systemctl --user enable --now caelestia-upstream-check.timer
echo "[install] systemd timer enabled"

# --- 6. Ensure QML_IMPORT_PATH env fragment ---
HYPR_CONFD="$HOME/.config/hypr/conf.d"
mkdir -p "$HYPR_CONFD"
ENV_FILE="$HYPR_CONFD/qml-import-path.conf"
if ! grep -q "QML_IMPORT_PATH" "$ENV_FILE" 2>/dev/null; then
  cat > "$ENV_FILE" <<'EOF'
# Prepend user-local Qt6 QML modules so the locally-built Caelestia plugin
# takes precedence over any system-installed version.
env = QML_IMPORT_PATH,$HOME/.local/lib/qt6/qml:$QML_IMPORT_PATH
EOF
  echo "[install] wrote $ENV_FILE"
else
  echo "[install] $ENV_FILE already has QML_IMPORT_PATH; skipping"
fi

echo "[install] Done. Log out + log back in to start Caelestia."
