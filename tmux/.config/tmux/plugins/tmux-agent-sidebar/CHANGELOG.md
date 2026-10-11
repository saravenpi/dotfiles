# Changelog

## 0.7.0

### Added

- Bulle harness support with hooks/bulle-hook.sh and detect.sh process detection

### Changed

- Renamed kori harness references to bulle throughout (detect.sh, agent-hook.sh)

### Fixed

- Go canvas: reduced function count from 14 to 8, split long functions, added `set -u` to all shell scripts
- Shell scripts: all long lines under 120 chars, `set -u` added to toggle.sh, canvas.sh, ensure.sh, statusline.sh; `set -euo pipefail` to autoclose.sh

## 0.6.0

### Added

- Antigravity CLI (agy) harness support with hooks/antigravity-hook.sh and detect.sh process detection

## 0.4.1

### Fixed

- Sidebar window now auto-closes when its last non-canvas pane exits: `pane-died` only fires with `remain-on-exit` on, so the per-window hook never ran; it is now `pane-exited`

## 0.4.0

### Added

- Blank spacing line between agent entries in the sidebar

### Changed

- Title reads "Agents"

### Fixed

- Hook `set` command was completely broken: `local` outside a function aborted before writing state
- Sidebar sorts windows numerically, so window 10 no longer sorts before window 2; ties within a window order by pane id

## 0.3.0

### Added

- New bubbletea canvas renderer (`cmd/sidebar`) with MiniDot spinners, status colors, and per-pane harness labels
- State JSON and detection now track which harness (nacelle, claude, codex) owns each pane
- Hooks export `HARNESS` explicitly; stale hook state is pruned when no agent process remains in the pane

### Fixed

- Pane pruning no longer false-matches on pane-id prefixes

## 0.2.2

### Fixed

- Sidebar pane now opens at the far left edge of the window in every layout, and focus returns to the leftmost non-canvas pane

## 0.2.1

### Changed

- Extra blank line above the " agents" title and a leading space before spinner/status icons

## 0.2.0

### Changed

- Auto-close is scoped per window via a `pane-died` hook set when the canvas pane is created, instead of global `pane-died` / `after-kill-pane` hooks that scanned every session
- Auto-close never kills the last window of a session
- Toggle key moved from `prefix + A` to `prefix + b`
- `ensure.sh` opens the Go canvas (was still launching the bash renderer)

### Fixed

- Killing a window whose last pane was the canvas could kill the whole session through the global hook chain
