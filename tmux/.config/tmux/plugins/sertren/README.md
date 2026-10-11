# Sertren - Simple Tmux Session Manager

**Sertren** is a minimal tmux plugin for smart session management with fuzzy finding and zoxide integration.

## Features

- **Session Switcher**: Navigate between sessions or create new ones with fzf
- **Zoxide Integration**: Auto-detects project paths using zoxide
- **Egg Layout Support**: Auto-applies tmux layouts if `egg.yml` exists
- **Session/Window Renaming**: Quick renaming with native tmux prompts
- **Safety Features**: Confirmation dialogs for destructive operations

## Installation

### Using TPM (Tmux Plugin Manager)

Add to your `~/.tmux.conf`:

```bash
set -g @plugin 'saravenpi/sertren'
```

Then press `prefix + I` to install.

### Manual Installation

```bash
git clone https://github.com/saravenpi/sertren ~/.tmux/plugins/sertren
```

Add to `~/.tmux.conf`:

```bash
run-shell ~/.tmux/plugins/sertren/sertren.tmux
```

Reload tmux:

```bash
tmux source-file ~/.tmux.conf
```

## Dependencies

### Required
- **tmux**
- **fzf** - For the session switcher

### Optional
- **zoxide** - For intelligent path detection
- **egg** - For automatic tmux layout application

## Default Key Bindings

| Key | Action |
|-----|--------|
| `prefix + o` | Session Switcher |
| `prefix + s` | Session Switcher (alternative) |
| `prefix + r` | Rename Window |
| `prefix + R` | Rename Session |
| `prefix + x` | Kill Pane (with confirmation) |
| `prefix + X` | Kill Window (with confirmation) |
| `prefix + Q` | Kill Session (with confirmation) |

## Configuration

Customize key bindings in `~/.tmux.conf`:

```bash
set -g @sertren_session_switcher_key 'o'
set -g @sertren_session_rename_key 'R'
set -g @sertren_window_rename_key 'r'
set -g @sertren_kill_pane_key 'x'
set -g @sertren_kill_window_key 'X'
set -g @sertren_kill_session_key 'Q'
```

## Usage

### Session Switcher

Press `prefix + o` to open the session switcher:

1. **Switch to existing sessions** - Use fzf to fuzzy search and select
2. **Create new sessions** - Select `[new session]` and enter a name:
   - Matches zoxide paths if available
   - Falls back to directory path or home directory

### Renaming

- **Windows**: `prefix + r` - Native tmux prompt
- **Sessions**: `prefix + R` - Native tmux prompt

Press `Ctrl+C` or `Escape` to cancel.

### Safety Features

- **Kill Pane**: `prefix + x` - Asks for confirmation
- **Kill Window**: `prefix + X` - Asks for confirmation
- **Kill Session**: `prefix + Q` - Asks for confirmation

## Integration

### Zoxide
When creating new sessions, Sertren uses zoxide to find project directories:
1. Exact match lookup
2. Partial match search
3. Fallback to directory path or home

### Egg
If `egg.yml` exists in a project directory, Sertren automatically runs `egg --current` when creating a new session.

## File Structure

```
sertren/
├── sertren.tmux              # Main plugin file
├── README.md
├── LICENSE
└── scripts/
    ├── session-switcher.sh   # Smart session switcher
    ├── rename-session.sh     # Session renaming
    ├── rename-window.sh      # Window renaming
    ├── confirm-kill-pane.sh  # Safe pane killing
    └── confirm-kill-session.sh # Safe session killing
```

## License

MIT License - see LICENSE file for details.

## Author

Created by [saravenpi](https://github.com/saravenpi)
