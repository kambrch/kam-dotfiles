#!/usr/bin/env bash
# Dependency tracer for Phase 2+ widget ports (cheatsheet, dock, desktop clock/weather).
#
# STATUS: STUB. Behavior defined when first Phase 2+ port is executed.
#
# Intended use:
#   kam/trace-deps.sh <widget-source-path>
# Output:
#   List of all .qml files transitively imported by the widget under the
#   given path, scoped to qs.modules.common.* and qs.services.* (the ii
#   utility trees that need to be vendored into modules/kam-vendored/).
#
# See: kam/docs/PORTING_GUIDE.md for the full porting procedure.

echo "trace-deps.sh: not yet implemented. See kam/docs/PORTING_GUIDE.md." >&2
exit 1
