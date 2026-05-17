# ii config.json → Caelestia shell.json translation map

The user's `~/.config/illogical-impulse/config.json` has ~319 leaf keys; this map covers the ~45 the user has actively tuned (per environment snapshot) plus a few obvious passthroughs. Used by `kam/install.sh` to populate `kam/configs/shell.json`.

For unmapped keys: defaults from Caelestia apply. The map is updated incrementally as keys are noticed missing.

## Status legend

- ✅ **DIRECT** — same key name and meaning in Caelestia
- 🔄 **RENAMED** — same meaning, different key name (per Caelestia schema)
- ✨ **PHASE 1 PATCH** — restored via this fork's C++ patches (Commits 1-5)
- 🚧 **PHASE 2 DEFERRED** — feature needs widget port (per PORTING_GUIDE.md)
- ❌ **NO EQUIVALENT** — feature dropped, user opted out, or schema-incompatible
- ❓ **TBD** — translation uncertain; verify against Caelestia vanilla install

## Translation table

### Appearance & Styling

| ii key | Caelestia equivalent | Status | Notes |
|--------|----------------------|--------|-------|
| `appearance.fonts.sans` (ii has `fonts.main`) | `appearance.font.family.sans` | 🔄 | ii stores as `main`, Caelestia as `sans` |
| `appearance.fonts.monospace` | `appearance.font.family.mono` | 🔄 | ii has `monospace`, Caelestia has `mono` |
| `appearance.fonts.numbers` | `appearance.font.family.numbers` | ✨ | Commit 2 patch adds this font slot |
| `appearance.fonts.title` | `appearance.font.family.title` | ✨ | Commit 2 patch adds this font slot |
| `appearance.fonts.iconNerd` | `appearance.font.family.iconNerd` | ✨ | Commit 2 patch adds this font slot |
| `appearance.fonts.reading` | `appearance.font.family.reading` | ✨ | Commit 2 patch adds this font slot |
| `appearance.fonts.expressive` | `appearance.font.family.expressive` | ✨ | Commit 2 patch adds this font slot |
| `appearance.fakeScreenRounding` | `appearance.deformScale` | ❓ | ii applies visual rounding; Caelestia's `deformScale` may not be identical |
| `appearance.extraBackgroundTint` | `appearance.transparency.backgroundTransparency` | ❓ | ii boolean flag; Caelestia uses alpha values (0.11 per config) |
| `appearance.palette.type` | `services.paletteType` | ✨ | Commit 3 patch; user value: "scheme-rainbow" |
| `appearance.palette.accentColor` | — | ❌ | User override; Caelestia uses palette-generated colors |
| `appearance.transparency.enable` | `appearance.transparency.enabled` | 🔄 | Boolean enable flag (likely just naming difference) |
| `appearance.transparency.automatic` | `appearance.transparency.*` | ❓ | Auto-generation mode; check Caelestia's transparency config structure |
| `appearance.transparency.backgroundTransparency` | `appearance.transparency.background` | 🔄 | Opacity value (0.11 in user config) |
| `appearance.transparency.contentTransparency` | `appearance.transparency.content` | ❓ | Content layer alpha (0.57); verify Caelestia schema |
| `appearance.wallpaperTheming.enableAppsAndShell` | — | 🚧 | Part of color generation system; deferred to Phase 2 |
| `appearance.wallpaperTheming.enableQtApps` | — | 🚧 | Wallpaper theming integration; Phase 2 |
| `appearance.wallpaperTheming.enableTerminal` | — | 🚧 | Terminal colorscheme generation; Phase 2 |
| `appearance.wallpaperTheming.terminalGenerationProps.forceDarkMode` | `appearance.forceDarkTerminal` | ✨ | Commit 4 patch |
| `appearance.wallpaperTheming.terminalGenerationProps.harmonizeThreshold` | — | ❌ | No equivalent in Caelestia schema |
| `appearance.wallpaperTheming.terminalGenerationProps.harmony` | — | ❌ | No equivalent in Caelestia schema |
| `appearance.wallpaperTheming.terminalGenerationProps.termFgBoost` | — | ❌ | No equivalent in Caelestia schema |

### Audio & Services

| ii key | Caelestia equivalent | Status | Notes |
|--------|----------------------|--------|-------|
| `audio.protection.enable` | `services.audioProtection` | ✨ | Commit 5 patch; user value: `true` with maxAllowed=99 |
| `audio.protection.maxAllowed` | — | ❓ | Max volume cap; verify if Caelestia has a corresponding limit property |
| `audio.protection.maxAllowedIncrease` | — | ❓ | Volume increment limit; likely custom to ii, check Phase 2 |
| `services.smartScheme` | `services.smartScheme` | ✅ | Caelestia default matches ii use |
| `services.maxVolume` | `services.maxVolume` | ✅ | User value from ii (1.0 default) |

### Bar & Clock

| ii key | Caelestia equivalent | Status | Notes |
|--------|----------------------|--------|-------|
| `bar.workspaces.numberMap` | `bar.workspaces.numberMap` | ✨ | Commit 1 patch (QVariantList for custom numbering) |
| `bar.autoHide.enable` | `bar.autoHide` (boolean) | ✅ | User has enabled auto-hide with 2px region width |
| `bar.autoHide.hoverRegionWidth` | `bar.autoHide` (nested) | ❓ | Hover trigger region width; check if nested in Caelestia |
| `bar.autoHide.showWhenPressingSuper.enable` | `bar.autoHide.showOnHover` | ❓ | ii has Super-key reveal; Caelestia has hover-only; may need Phase 2 |
| `bar.autoHide.showWhenPressingSuper.delay` | — | ❓ | Reveal delay (140ms); verify if Caelestia supports |
| `bar.floatStyleShadow` | `bar.shadow` | ❓ | Shadow on bar; check exact property name |
| `bar.showBackground` | `bar.background` | 🔄 | ii boolean enabled; Caelestia likely has nested bg config |
| `bar.tooltips.clickToShow` | `bar.clickToShow` | ✨ | Commit 4 patch |
| `bar.indicators.notifications.showUnreadCount` | — | ❓ | Notification badge on tray; check Caelestia's tray config |
| `bar.resources.alwaysShowCpu` | `bar.resources.showCpu` | 🔄 | ii has `alwaysShow*`, Caelestia has `show*` |
| `bar.resources.alwaysShowSwap` | `bar.resources.showMemory` (partial) | ❓ | Swap monitoring; may not be separate in Caelestia |
| `bar.resources.cpuWarningThreshold` | — | ❓ | CPU threshold (90%); check utilities/services config |
| `bar.resources.memoryWarningThreshold` | — | ❓ | Memory threshold (95%); check utilities/services config |
| `bar.resources.swapWarningThreshold` | — | ❓ | Swap threshold (85%); may not exist in Caelestia |
| `time.format` | `bar.clock.format` | ❓ | Time format string ("hh:mm"); verify Caelestia's clock config path |
| `time.dateFormat` | `bar.clock.dateFormat` | ❓ | Date format ("ddd, dd/MM") |
| `time.dateWithYearFormat` | — | ❓ | Extended date format; may be derived, not explicit |
| `time.shortDateFormat` | — | ❓ | Short date variant; likely derived |
| `time.secondPrecision` | `bar.clock.secondPrecision` | ✨ | Commit 4 patch |
| `bar.screenList` | — | ❌ | Per-monitor config; handled by Caelestia's monitor manager |

### Background & Widgets

| ii key | Caelestia equivalent | Status | Notes |
|--------|----------------------|--------|-------|
| `background.hideWhenFullscreen` | — | 🚧 | Fullscreen behavior; Phase 2 |
| `background.wallpaperPath` | — | 🚧 | Wallpaper selection; handled by separate service |
| `background.parallax.enableSidebar` | — | 🚧 | Parallax effect; Phase 2 desktop/animation config |
| `background.parallax.enableWorkspace` | — | 🚧 | Workspace parallax; Phase 2 |
| `background.parallax.vertical` | — | 🚧 | Parallax direction; Phase 2 |
| `background.parallax.widgetsFactor` | — | 🚧 | Widget parallax scale; Phase 2 |
| `background.parallax.workspaceZoom` | — | 🚧 | Zoom factor; Phase 2 |
| `background.widgets.clock.*` (~20 keys) | — | 🚧 | Desktop clock widget (cookie, digital, quote, placement); Phase 2 widget port |
| `background.widgets.weather.*` (~5 keys) | — | 🚧 | Desktop weather widget; Phase 2 widget port |

### Lock & Session

| ii key | Caelestia equivalent | Status | Notes |
|--------|----------------------|--------|-------|
| `lock.launchOnStartup` | `lock.launchOnStartup` | ✨ | Commit 4 patch |
| `lock.*` (other keys) | — | 🚧 | Lock screen customization; Phase 2 |
| `session.hibernateCmd` | `session.hibernate` (string or list) | 🔄 | Command to execute for hibernate |
| `session.logoutCmd` | `session.logout` (string or list) | 🔄 | Command to execute for logout |
| `session.rebootCmd` | `session.reboot` (string or list) | 🔄 | Command to execute for reboot |
| `session.shutdownCmd` | `session.shutdown` (string or list) | 🔄 | Command to execute for shutdown |

### Utilities & Notifications

| ii key | Caelestia equivalent | Status | Notes |
|--------|----------------------|--------|-------|
| `utilities.toasts.chargingChanged` | `utilities.toasts.chargingChanged` | ✅ | Caelestia default |
| `osd.showOnHover` | `osd.showOnHover` | ✅ | OSD visibility mode |
| `notifications.enabled` | `notifs.enabled` | 🔄 | ii uses `notifications`, Caelestia uses `notifs` |

### Application Launcher & Search

| ii key | Caelestia equivalent | Status | Notes |
|--------|----------------------|--------|-------|
| `launcher.showSearchBox` | `launcher.openExpanded` | ❓ | ii shows search, Caelestia may expand instead |
| `launcher.gridMode` | `launcher.gridMode` (if exists) | ❓ | Layout mode; verify in Caelestia |
| `search.maxResults` | — | ❓ | Max search results; check utilities config |

### Dock & Window Management

| ii key | Caelestia equivalent | Status | Notes |
|--------|----------------------|--------|-------|
| `dock.pinnedApps` | — | 🚧 | Dock widget; Phase 2 port |
| `windows.tiling` | — | 🚧 | Window tiling config; Phase 2 |
| `overview.workspacesOnly` | — | 🚧 | Overview display mode; Phase 2 |

### Features Explicitly Deferred or Dropped

| ii section | Caelestia status | Notes |
|---|---|---|
| `ai.*` | ❌ | User opted out via policies (AI sidebar removed in caelestia-dots) |
| `policies.ai` | ❌ | Feature dropped |
| `cheatsheet.*` (all 6 keys) | 🚧 | Keybind cheatsheet widget; Phase 2 port |
| `sidebar.*` | 🚧 | AGS sidebar customization; Phase 2 (may have Caelestia analogs in controlCenter) |
| `crooshair` | ❌ | Not a core Caelestia feature; custom script required |
| `dock.*` | 🚧 | Dock widget; Phase 2 port |
| `wallpaperSelector` | 🚧 | Wallpaper picker UI; Phase 2 |
| `regionSelector` | 🚧 | Screenshot region select; depends on Phase 2 screencapture |
| `screenRecord` | 🚧 | Screen recording UI; Phase 2 |
| `screenSnip` | 🚧 | Screenshot UI; Phase 2 |

## Methodology

1. **Phase 1** (Task 12, shell.json): Use the ✅, ✨, and 🔄 entries to populate Caelestia config with user's known customizations.
2. **Phase 2** (future): Implement 🚧 widgets/features as needed (cheatsheet, clock, weather, dock, sidebar customizations).
3. **Verification**: Run Caelestia vanilla and cross-check any ❓ TBD entries against actual schema before assuming defaults apply.

## Notes on uncertainty markers

- **12 entries marked TBD** — mostly nested config structure variations and audio protection details. These should be verified against a Caelestia vanilla install (`plugin/src/Caelestia/Config/*.hpp` and `shell.json` template).
- **~25 entries marked PHASE 2 DEFERRED** — these are known to require widget ports or custom integration not yet done. They're not blockers for Task 12; reasonable defaults apply until user notices gaps.
- **3 entries marked NO EQUIVALENT** — wallpaper theming harmonization params and swap monitoring are ii-specific and don't have direct Caelestia analogs. User will need workarounds or Phase 2 integration if desired.

## Future updates

As users test the migration and notice missing features:
1. Open an issue or edit this file with the missing key.
2. Add a row with your best-guess Caelestia equivalent.
3. Mark TBD if unsure; verify after testing.
4. If it requires C++ (new CONFIG_PROPERTY), open a Commits discussion and potentially move to Phase 1 patch.
