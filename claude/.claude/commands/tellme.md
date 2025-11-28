---
allowed-tools: Bash(curl :*)
description: Send a notification message using the tellme system
---

Send a notification using `curl -d "<message>" "$NTFY_SH"` to notify about completed work or important updates.

**Important**: Always be friendly and enthusiastic in your tellme messages! Use emojis to make them more visual and engaging. The message should be comprehensive and detailed about what was accomplished.

## Detailed Notification Requirements

tellme notifications must include comprehensive details about what was accomplished:

### For Code Changes:
- 📁 Specific files modified/created with paths
- 🔧 Key functions/features implemented  
- 🐛 Bugs fixed with brief description
- ⚡ Performance improvements made
- 🔗 Integration points added/modified

### For Commits:
- 📝 Full commit message and hash
- 📊 Statistics (files changed, lines added/removed)
- 🌿 Branch information
- 🎯 Key accomplishments in bullet points

### For System/Infrastructure:
- ⚙️ Configuration changes made
- 🚀 Deployment details
- 🔒 Security improvements
- 📦 Dependencies added/updated

### Format Template:
```
[Main Achievement Emoji] [Brief Title]

[Detailed Description]

✨ Key accomplishments:
• [Specific achievement 1]
• [Specific achievement 2] 
• [Specific achievement 3]

📊 Impact: [Statistics]
🔗 Technical details: [Hashes, branches, etc.]
🎯 Result: [Outcome/benefit]
```

### Examples of detailed notifications:
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