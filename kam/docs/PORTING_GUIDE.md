# Phase 2+ widget porting guide

This document describes how to bring forward a widget from the archived `ii`
config (in `~/.config/.archived-ii-YYYY-MM-DD/`) into the kam fork as a vendored,
namespaced widget. Triggered by actual missed-feature pain in daily use.

## Priority order

| # | Widget | Estimated size | Trigger condition |
|---|--------|----------------|-------------------|
| 1 | Desktop floating clock + weather | ~21 files + vendored deps | "I miss the cookie clock" |
| 2 | Cheatsheet (Super+/) | 5 files + vendored deps | "I keep hitting Super+/" |
| 3 | Dock with pinned apps | 5 files + vendored deps | "Caelestia launcher isn't enough" |

## Per-port procedure

1. **Source paths**
   - Widget source: `~/.config/.archived-ii-YYYY-MM-DD/quickshell/ii/modules/ii/<widget>/`
   - ii utilities: `~/.config/.archived-ii-YYYY-MM-DD/quickshell/ii/modules/common/`
                  `~/.config/.archived-ii-YYYY-MM-DD/quickshell/ii/services/`

2. **Generate dependency closure**
   ```sh
   kam/trace-deps.sh ~/.config/.archived-ii-YYYY-MM-DD/quickshell/ii/modules/ii/<widget>/
   ```
   Output: list of transitively-imported files from `qs.modules.common.*` and `qs.services.*`.

3. **Vendor into kam-vendored namespace**
   ```sh
   mkdir -p ~/kam-dotfiles/modules/kam-vendored/{common,services}
   # Copy widget files
   cp -r ~/.config/.archived-ii-YYYY-MM-DD/quickshell/ii/modules/ii/<widget>/ \
         ~/kam-dotfiles/modules/<widget>/
   # Copy dep closure
   # (trace-deps.sh should output a script that does this)
   ```

4. **Rewrite imports**
   In all copied files, rewrite:
   - `import qs.modules.common.*` → `import qs.modules.kam-vendored.common.*`
   - `import qs.services.*` → `import qs.modules.kam-vendored.services.*`

   Use sed or your editor's project-wide replace.

5. **Patch shell.qml** to instantiate the widget:
   ```qml
   // Inside ShellRoot
   <WidgetName> {}
   ```

6. **Add any new CONFIG_PROPERTY entries** the widget needs (per the same pattern as Phase 1 commits 1–5):
   - Add to relevant `plugin/src/Caelestia/Config/*.hpp`
   - Build to verify

7. **Test live**:
   ```sh
   cmake --build build && pkill quickshell
   hyprctl dispatch exec caelestia-shell
   ```

8. **Commit**:
   ```sh
   git add modules/ shell.qml plugin/
   git commit -m "kam-port: <widget> (incl. N vendored utility files)"
   git push
   ```
   No rebase needed for additive ports — vendored code lives in namespace upstream never touches.

## Risks per port

- **Desktop floating clock+weather**: includes a `periodic_table.js` data file and date/weather sub-widgets. ~21 files. Largest port. Weather widget pulls from `services.weather` which itself depends on a weather API service — verify the service still works or update API.
- **Cheatsheet**: depends on Hyprland keybind parsing — verify `~/.config/hypr/keybinds.conf` is still readable in the expected format under Caelestia's Hyprland layout.
- **Dock**: depends on `Hyprland` Quickshell module for client introspection. Lightweight.
