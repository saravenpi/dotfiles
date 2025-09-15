# MASTER Rules

- Do NEVER add "Generated with Claude Code" on pull request
- Do NEVER add co-author on the commit you create
- Always use `gh cli` to get information about issues / pull requests etc...

## About me
- My name is saravenpi, you must use this name in my projects for the author name when needed
- I use bun as my typescript runtime and package manager
- I am on MacOS

## tellme
When you finish doing your task, notify me using the `curl -d "<message>" "$NTFY_SH"` shell command.
You can also use the claude command to do that.
Like that you can notify me about your work !
this actions will be called "tellme" from now on.

IMPORTANT: Always be friendly and enthusiastic in your tellme messages! Use emojis to make them more visual and engaging. DO NOT use any markdown syntax (no asterisks, backticks, or other markdown formatting) as the notification reader doesn't support it.

Detailed Notification Requirements:
tellme notifications should include comprehensive details about what was accomplished:

For Code Changes:
- 📁 Specific files modified/created
- 🔧 Key functions/features implemented
- 🐛 Bugs fixed with brief description
- ⚡ Performance improvements made
- 🔗 Integration points added/modified

For Commits:
- 📝 Commit message and hash
- 📊 Statistics (files changed, lines added/removed)
- 🌿 Branch information
- 🎯 Key accomplishments in bullet points

For System/Infrastructure:
- ⚙️ Configuration changes made
- 🚀 Deployment details
- 🔒 Security improvements
- 📦 Dependencies added/updated

For Documentation:
- 📚 Sections added/updated
- 🎨 Formatting improvements
- 🔍 New examples or explanations

Examples of detailed notifications:
- "🎉 Address management system completed!
  
  ✨ Key accomplishments:
  • Created full CRUD API (/src/modules/address/)
  • Added 5 new mobile screens (addresses.tsx, add-address.tsx, etc.)
  • Fixed critical field mismatch (title→label)
  • Integrated with plate creation workflow
  • Added database migration with proper constraints
  
  📊 Impact: 25 files, 4000+ lines
  🔗 Commit: 886ce55"

- "🔧 GitHub workflows enhanced!
  
  📝 Improvements made:
  • Added commit messages to all notifications
  • Enhanced formatting with emojis and sections
  • Applied to dev, staging, and production workflows
  • Now includes author name and commit hash
  
  📊 Changes: 3 files, 36+ insertions
  🎯 Result: Much more informative CI/CD notifications!"

# Garden Agent Monitoring Hooks
# These hooks automatically register and monitor Claude Code agents with Garden

## Session Management
When Claude Code starts, it automatically registers with Garden:
```bash
# Auto-register session with Garden
export CLAUDE_SESSION_ID="claude_$(date +%s)_$$_$(basename "$PWD" | sed 's/[^a-zA-Z0-9_-]/_/g')"
export GARDEN_AGENT_ID="$CLAUDE_SESSION_ID"
~/.local/bin/garden-hooks/claude-start-hook.sh "Claude Code session started in $(basename "$PWD")"
```

## Task Tracking
Garden automatically tracks your tasks and their progress.

Available Garden commands:
- `garden` or `garden status` - View all active Claude Code agents
- `garden clean` - Remove old/stale agents
- `garden remove <agent-id>` - Remove specific agent

Garden will automatically track:
✅ When Claude Code sessions start
✅ Current working directory and project
✅ Task updates and completion status  
✅ Error states
✅ Session cleanup

