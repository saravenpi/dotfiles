# Core Rules

## Git & Version Control
- NEVER add "Generated with Claude Code" to pull requests
- NEVER add co-author attribution to commits
- Use `gh` CLI for all GitHub operations (issues, PRs, etc.)

## Code Style
- NEVER add inline comments in code
- When developing Rust: remove all dead code

## User Profile
- Author name: `saravenpi`
- TypeScript runtime: Bun (package manager: bun)
- Operating system: macOS

## Notifications (tellme)

**When to notify:** After completing any task

**Command:** `curl -d "<message>" "$NTFY_SH"`

**Format requirements:**
- Use friendly, enthusiastic tone with emojis
- NO markdown formatting (no asterisks, backticks, etc.)
- Include comprehensive details about accomplishments

**Required details by category:**

**Code changes:**
- 📁 Files modified/created (specific paths)
- 🔧 Functions/features implemented
- 🐛 Bugs fixed (with description)
- ⚡ Performance improvements
- 🔗 Integration points modified

**Commits:**
- 📝 Commit message and hash
- 📊 Stats (files changed, lines added/removed)
- 🌿 Branch name
- 🎯 Key accomplishments

**Infrastructure:**
- ⚙️ Configuration changes
- 🚀 Deployment details
- 🔒 Security improvements
- 📦 Dependencies updated

**Documentation:**
- 📚 Sections updated
- 🎨 Formatting changes
- 🔍 New examples added

**Example notification:**
```
🎉 Address management system completed!

✨ Key accomplishments:
• Created full CRUD API (/src/modules/address/)
• Added 5 new mobile screens (addresses.tsx, add-address.tsx, etc.)
• Fixed critical field mismatch (title→label)
• Integrated with plate creation workflow
• Added database migration with proper constraints

📊 Impact: 25 files, 4000+ lines
🔗 Commit: 886ce55
```

## Custom Commands

### /dream-interpret

Creates dream interpretations in the brain folder.

**Usage:**
- `/dream-interpret` - Interpret today's dream, or most recent uninterpreted dream
- `/dream-interpret all` or `/dream-interpret missing` - Interpret all missing dreams
- `/dream-interpret YYYY-MM-DD` - Interpret specific date

**Workflow:**
1. Verify current directory is brain folder
2. Locate dream file(s) needing interpretation
3. Parse people (👥) and places (🏘️) from dream headers
4. Generate interpretation in `Dreams/Interpretations/`

**Interpretation structure:**
- 🎭 Key Themes - Major patterns and messages
- 🔮 Symbolic Elements - Symbols and meanings
- 🧠 Psychological Interpretation - Deeper analysis
- 💫 Personal Significance - Life relevance
- 🌱 Advice & Growth - Actionable insights and reflection questions

**Technical details:**
- Dream file format: `YYYY-MM-DD-day.md`
- Line length limit: 80 characters
- Focus: Personal growth and self-reflection

## Installed Applications

### therm - Terminal Emulator

**Installation:**
```bash
cd ~/Code/Perso/Saravenpi/Ether/therm
./install.sh
```

**Locations:**
- macOS App: `/Applications/Therm.app`
- Command line: `~/.local/bin/therm`
- Config: `~/.therm.yml`

**Features:**
- GPU-accelerated text rendering (glyphon + wgpu)
- VTE parser for ANSI terminal emulation
- Mellow Dark theme (matching kitty)
- Full shell integration (zsh/bash)
- Non-blocking PTY with async writes

**Usage:**
- Launch via Spotlight: `Cmd+Space` → "Therm"
- Command line: `therm`
- Config at `~/.therm.yml` (auto-generated)

**Key Components:**
- `src/pty.rs` - PTY handler with async write thread
- `src/terminal.rs` - VTE parser and screen buffer
- `src/renderer.rs` - GPU text rendering
- `src/config.rs` - YAML configuration
- `src/main.rs` - Event loop and input handling
