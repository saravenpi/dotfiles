---
allowed-tools: Glob, Read, Edit, MultiEdit, Grep
description: Remove all inline comments from code and add clean JSDoc-style function descriptions for JS/TS files.
---

## Clean Comments Command

Removes ALL inline comments, comment blocks within function bodies, and other scattered comments while adding clean, professional JSDoc-style comments above functions (for JS/TS) or appropriate doc comments for other languages.

### Process:

1. **File Discovery**: Find all code files in the project using appropriate patterns
2. **Language Detection**: Identify file types to apply correct comment processing
3. **Comment Removal**: Remove all inline comments (`//`, `/* */`, `#`, etc.) from:
   - Inside function/method bodies  
   - Variable declarations
   - Code blocks
   - Inline explanations
4. **Function Documentation**: Add clean top-level comments above functions:
   - **JavaScript/TypeScript**: JSDoc format with `@param`, `@returns`, `@description`
   - **Python**: Docstring format  
   - **Java/C#**: JavaDoc/XML doc format
   - **Other languages**: Appropriate documentation format

### Features:
- Preserves license headers and copyright notices
- Maintains essential TODO/FIXME comments (optional flag)
- Handles multiple comment styles per language
- Generates meaningful function descriptions based on code analysis
- Preserves code formatting and indentation

### Supported Languages:
- JavaScript/TypeScript (JSDoc)
- Python (docstrings)
- Java (JavaDoc)
- C#/C++ (XML/Doxygen)
- Go (godoc)
- Rust (rustdoc)
- PHP (PHPDoc)

### Example Before:
```javascript
// This function calculates something
function calculateTotal(items) {
    // Loop through all items
    let total = 0;
    for (let item of items) { // Add each item price
        total += item.price; // Running total
    }
    return total; // Return the final sum
}
```

### Example After:
```javascript
/**
 * Calculates the total price of all items in the collection.
 * @param {Array<Object>} items - Array of items with price properties
 * @returns {number} The sum of all item prices
 */
function calculateTotal(items) {
    let total = 0;
    for (let item of items) {
        total += item.price;
    }
    return total;
}
```

### Options:
- `--preserve-todos`: Keep TODO/FIXME/HACK comments
- `--dry-run`: Preview changes without applying them
- `--exclude`: Skip certain file patterns or directories