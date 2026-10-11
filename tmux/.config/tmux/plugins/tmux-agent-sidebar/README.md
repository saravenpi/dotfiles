# tmux-agent-sidebar

A toggleable left sidebar for tmux showing a per-window/per-pane summary and
status of AI coding agents (Claude Code, Codex, Bulle, or any agent you wire up).

Original implementation, no external plugin code. State flows through small
JSON status files under `~/.cache/tmux-agent-sidebar/`, written by agent
lifecycle hooks, read by the sidebar renderer. Hook-driven state beats process
polling: polling only tells you a binary is running, hooks tell you the agent
is working, waiting for you, or done.

States:

| state    | symbol | meaning                          |
|----------|--------|----------------------------------|
| working  | ▸      | agent is executing a turn        |
| waiting  | ?      | agent needs your input           |
| done     | ✓      | agent finished its turn          |
| idle     | ·      | registered but not active        |

## Install

With TPM:

```tmux
set -g @plugin 'saravenpi/tmux-agent-sidebar'
```

Then `prefix + I`. Options:

```tmux
set -g @tmux-agent-sidebar-width 28      # sidebar pane width
set -g @tmux-agent-sidebar-interval 2    # renderer refresh seconds
set -g @tmux-agent-sidebar-key B         # toggle key (prefix b)
```

Manual install: clone this repo anywhere and add:

```tmux
run '~/.tmux/plugins/tmux-agent-sidebar/tmux-agent-sidebar.tmux'
```

Toggle with `prefix + b`.

## Status bar mode

Instead of (or alongside) the sidebar, add one symbol per agent to the status
line:

```tmux
set -g status-right "#(bash ~/.tmux/plugins/tmux-agent-sidebar/scripts/statusline.sh) #S"
```

## Hook setup

### Claude Code

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      { "hooks": [ { "type": "command",
        "command": "bash ~/.tmux/plugins/tmux-agent-sidebar/hooks/claude-hook.sh UserPromptSubmit" } ] }
    ],
    "PreToolUse": [
      { "hooks": [ { "type": "command",
        "command": "bash ~/.tmux/plugins/tmux-agent-sidebar/hooks/claude-hook.sh PreToolUse" } ] }
    ],
    "Notification": [
      { "hooks": [ { "type": "command",
        "command": "bash ~/.tmux/plugins/tmux-agent-sidebar/hooks/claude-hook.sh Notification" } ] }
    ],
    "Stop": [
      { "hooks": [ { "type": "command",
        "command": "bash ~/.tmux/plugins/tmux-agent-sidebar/hooks/claude-hook.sh Stop" } ] }
    ]
  }
}
```

### Codex CLI

Add to `~/.codex/hooks.json` with the same event names, pointing at
`hooks/codex-hook.sh`.

### Any other agent (nacelle, marcel, vero, antigravity, ...)

Call the CLI from a wrapper, cron, or the agent itself:

```sh
scripts/agent-state.sh set working "building ardoise"
scripts/agent-state.sh set waiting
scripts/agent-state.sh set done
scripts/agent-state.sh clear          # remove state for the current pane
```

State is keyed by `TMUX_PANE`, so a pane whose hook writes state shows in the
sidebar until cleared or until the file is removed. Stale files (pane gone)
can be pruned with `scripts/agent-state.sh clear <pane-id>`.

## Files

```
tmux-agent-sidebar.tmux   TPM entry point, binds prefix b
scripts/sidebar.sh        renderer loop (sidebar pane)
scripts/toggle.sh         create/kill the sidebar pane
scripts/statusline.sh     one-symbol-per-agent status-bar fragment
scripts/agent-state.sh    state CLI (set/get/clear)
hooks/claude-hook.sh      Claude Code hook adapter
hooks/codex-hook.sh       Codex hook adapter
hooks/antigravity-hook.sh  Antigravity CLI hook adapter
```

## Notes

- Hooks inherit `TMUX_PANE` when the agent runs inside tmux, which is how each
  state file lands on the right pane. Agents launched outside tmux are not
  tracked unless you pass a pane id explicitly.
- The renderer runs every `@tmux-agent-sidebar-interval` seconds; there is no
  daemon, only the pane's own loop.

## License

MIT