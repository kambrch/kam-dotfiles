# Rollback from Caelestia migration

This procedure restores the ii Quickshell setup from the pre-migration archive.

## Decide whether to roll back

| Symptom | Action |
|---------|--------|
| Desktop crashes on login; plugin fails to load; nothing renders | ROLL BACK (structural break) |
| Specific keybind not working; specific widget missing or misbehaving | DO NOT roll back — edit `kam/configs/hypr-user.conf` or `kam/configs/shell.json`, then reload |
| Caelestia rendering but feels worse; want to go back | Manual decision — both options valid |

## Rollback steps

1. **Stop the systemd timer:**
   ```sh
   systemctl --user disable --now caelestia-upstream-check.timer
   ```

2. **Remove user-local plugin install:**
   ```sh
   rm -rf ~/.local/lib/qt6/qml/Caelestia ~/.local/share/caelestia
   ```

3. **Remove symlinks created by install.sh:**
   ```sh
   for f in ~/.config/quickshell/caelestia \
            ~/.config/caelestia/hypr-user.conf \
            ~/.config/caelestia/hypr-vars.conf \
            ~/.config/caelestia/shell.json \
            ~/.config/caelestia/shell-tokens.json \
            ~/.config/hypr/scripts \
            ~/.config/systemd/user/caelestia-upstream-check.service \
            ~/.config/systemd/user/caelestia-upstream-check.timer; do
     [[ -L "$f" ]] && rm "$f"
   done
   systemctl --user daemon-reload
   ```

4. **Remove the QML_IMPORT_PATH env fragment:**
   ```sh
   rm -f ~/.config/hypr/conf.d/qml-import-path.conf
   ```

5. **Restore archived ii configs (replace <DATE> with the archive date):**
   ```sh
   archive=~/.config/.archived-ii-<DATE>
   for d in quickshell illogical-impulse hypr matugen; do
     [[ -d "$archive/$d" ]] && cp -r "$archive/$d" ~/.config/
   done
   ```

6. **Restore the hypr custom/ git stash if applied:**
   ```sh
   cd ~/.config/hypr/custom
   git stash list | grep pre-caelestia-migration  # find the stash
   git stash pop  # if a stash matches
   ```

7. **Log out / log back in** to restart Hyprland with the restored ii setup.

8. **Optionally remove `caelestia-cli`** (harmless if left installed):
   ```sh
   yay -R caelestia-cli
   ```

9. **Preserve `~/kam-dotfiles-new`** for a future retry — only delete after a successful re-migration or explicit abandonment.

## What's NOT undone by rollback

- Renamed GitHub repos (`kam-dotfiles` → `kam-dotfiles-legacy-end4` and the caelestia fork → `kam-dotfiles`). If you abandon the migration, manually rename them back via GitHub Settings.
- Any AUR deps installed for Caelestia (`caelestia-cli`, `quickshell-git`, etc.) — they don't conflict with ii so leave installed unless cleaning up.
