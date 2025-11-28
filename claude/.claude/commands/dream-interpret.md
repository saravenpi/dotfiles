# Dream Interpretation Command Handler

When the user runs `/dream-interpret`, follow these steps:

1. **Check current location**: Verify that the current working directory
   contains "brain" in the path. If not, inform the user this command only
   works in the brain folder.

2. **Mode Selection**:
   - If no arguments: First check for today's dream. If today's dream doesn't
     exist, find the most recent dream file that doesn't have an interpretation
     yet and interpret that one.
   - If argument contains "all" or "missing": find and interpret all missing
     interpretations
   - If argument contains a specific date: interpret that date's dream

3. **For default mode (no arguments)**:
   - First check for today's dream file
   - If today's dream exists, interpret it
   - If today's dream doesn't exist:
     * Find all dream files in Dreams/ folder
     * Check which ones don't have interpretations
     * Select the most recent dream without interpretation
     * If found, interpret it with message: "No dream for today. Found dream
       from [date] without interpretation. Creating interpretation..."
     * If all dreams have interpretations: "No dreams needing interpretation."

4. **For specific date**:
   - Format: YYYY-MM-DD-day (e.g., 2025-10-07-mon)
   - Day abbreviations: mon, tue, wed, thu, fri, sat, sun
   - Look for file: `Dreams/[date].md`
   - If not found, say: "No dream entry found for [date]."

4. **For missing interpretations mode**:
   - Find all dream files in Dreams/ folder
   - Check which ones don't have corresponding interpretations in
     Dreams/Interpretations/
   - Create a list of missing interpretations
   - Process each missing interpretation one by one
   - Report progress: "Found X dreams without interpretations. Processing..."

5. **Create interpretation** (keep lines under 80 characters):
   - Read the dream content
   - Parse for people (👥) and places (🏘️) from the header if present
   - Create interpretation file: `Dreams/Interpretations/[date].md`

6. **Use this interpretation structure**:

```markdown
# Dream Interpretation - [Full Date]

## 🎭 Key Themes
- **Theme 1**: Description that stays within line length limits
- **Theme 2**: Description broken into readable chunks if needed
- **Theme 3**: Clear and concise theme description

## 🔮 Symbolic Elements
- **Symbol 1**: Meaning explained in a clear, concise way
- **Symbol 2**: Significance within the dream context
- **Symbol 3**: Connection to waking life experiences

## 🧠 Psychological Interpretation
[Paragraph analyzing the dream psychologically. Keep each line under 80
characters for readability. Break longer thoughts into multiple sentences.
Focus on the deeper psychological meanings and patterns present in the
dream narrative.]

## 💫 Personal Significance
- First significant point about personal relevance
- Second point connecting to current life situations
- Third point about emotional or spiritual significance

## 🌱 Advice & Growth
### Things to work on:
- **Area 1**: Specific, actionable advice for improvement
- **Area 2**: Another area to focus on with clear guidance

### Things to continue:
- **Positive 1**: Strength to maintain and build upon
- **Positive 2**: Another positive pattern to reinforce

### Reflection questions:
- A thought-provoking question for deeper self-exploration?
- Another question to help integrate the dream's lessons?
```

7. **Special considerations**:
   - Focus on growth and self-reflection
   - Be supportive and insightful
   - Keep all markdown lines under 80 characters for better readability
   - Consider recurring themes from other dreams if relevant

8. **After creating**:
   - For single dream: "✨ Dream interpretation created for [date]!"
   - For multiple: "✨ Created X dream interpretations! Check
     Dreams/Interpretations/"
   - List the dates of interpretations created

9. **Line length note**:
   - Ensure all lines in the interpretation stay under 80 characters
   - Break longer thoughts into multiple lines or sentences
   - Use clear line breaks for readability in markdown viewers