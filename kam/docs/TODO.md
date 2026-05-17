# TODO: Deferred Config Knob Implementations

## clickToShow (Bar Tooltip Click-Instead-of-Hover)

**C++ Property**: `Config.bar.clickToShow` (boolean, default `false`)
- Location: `/plugin/src/Caelestia/Config/barconfig.hpp` line 135
- Status: C++ property added. QML wiring deferred.

**Reason for Deferral**: Tooltip/popout show behavior is implemented via hover detection in `modules/drawers/Interactions.qml` (line 218 calls `bar.checkPopout(y)` on mouse position changes). Integrating `clickToShow` would require:
1. Disabling hover-triggered popouts when the flag is enabled
2. Adding click/press detection to show popouts instead
3. Careful coordination with existing drag/shortcut logic in Interactions.qml

This is ~20+ lines of logic change across the Interactions flow and is beyond the "1-3 lines" threshold for best-effort wiring.

**Path for Future Implementation**:
- Modify `modules/drawers/Interactions.qml` `onPositionChanged` handler (line 217-222) to skip `checkPopout` when `Config.bar.clickToShow` is true
- Add `onPressed` or `onClicked` handler to call `checkPopout` only on click
- Test interactions with drag threshold and existing popout/tray logic

## forceDarkTerminal (Force Dark Mode for Terminal Palette)

**C++ Property**: `Config.appearance.forceDarkTerminal` (boolean, default `false`)
- Location: `/plugin/src/Caelestia/Config/appearanceconfig.hpp` line 246
- Status: C++ property added. QML wiring deferred.

**Reason for Deferral**: Terminal color generation logic lives in the **caelestia-cli** external repository, not in this codebase. The QML side (`services/Colours.qml`) only loads and applies the generated color scheme.

The service at line 72 of `services/Colours.qml` identifies terminal colors by the "term" prefix, but the actual palette generation (`generate_colors_material.py` and related CLI tools) is external.

**Path for Future Implementation**:
1. **CLI side** (caelestia-cli repo):
   - Modify the color generation script to accept and respect a `--force-dark-terminal` flag
   - Pass `Config.appearance.forceDarkTerminal` as an argument to the CLI call
   
2. **QML side** (this repo):
   - Modify `services/Colours.qml` line 79 (the `setMode` function or color generation trigger) to pass the flag to caelestia-cli:
     ```qml
     Quickshell.execDetached(["caelestia", "scheme", "set", "--notify", "-m", mode, 
         Config.appearance.forceDarkTerminal ? "--force-dark-terminal" : ""]);
     ```

## launchOnStartup (Lock Screen on Session Start)

**C++ Property**: `Config.lock.launchOnStartup` (boolean, default `false`)
- Location: `/plugin/src/Caelestia/Config/lockconfig.hpp` line 15
- Status: **IMPLEMENTED**

**Implementation**: 
- `shell.qml` (Component.onCompleted on Lock instance): checks `Config.lock.launchOnStartup` and calls `lock.lock.locked = true` if enabled
- No further action needed

---

## Summary

| Knob | Status | Line | Blocker |
|------|--------|------|---------|
| `secondPrecision` | ✅ Implemented | `Clock.qml` | None |
| `clickToShow` | 🟡 Deferred | `barconfig.hpp:135` | Complex hover/click coordination in Interactions.qml |
| `forceDarkTerminal` | 🟡 Deferred | `appearanceconfig.hpp:246` | Color generation is in external caelestia-cli repo |
| `launchOnStartup` | ✅ Implemented | `shell.qml` | None |
