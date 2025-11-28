---
allowed-tools: Glob, Read, Edit, MultiEdit, Grep
description: Remove all inline comments from code and add clean documentation (JSDoc for JS/TS, rustdoc for Rust).
---

## Clean Comments Command

Removes ALL inline comments, comment blocks within function bodies, and other scattered comments while adding clean, professional documentation above functions using language-appropriate formats.

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
   - **Rust**: Triple-slash `///` rustdoc format with markdown
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
- **JavaScript/TypeScript**: JSDoc format (`/** */`)
- **Rust**: rustdoc format (`///` with markdown)
- **Python**: Docstrings (`"""`)
- **Java**: JavaDoc format (`/** */`)
- **C#/C++**: XML/Doxygen comments
- **Go**: godoc format (`//`)
- **PHP**: PHPDoc format (`/** */`)

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

### Example After (JavaScript):
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

### Example After (Rust):
```rust
/// Calculates the total price of all items in the collection.
///
/// # Arguments
///
/// * `items` - A slice of items with price properties
///
/// # Returns
///
/// The sum of all item prices
pub fn calculate_total(items: &[Item]) -> f64 {
    let mut total = 0.0;
    for item in items {
        total += item.price;
    }
    total
}
```

### Options:
- `--preserve-todos`: Keep TODO/FIXME/HACK comments
- `--dry-run`: Preview changes without applying them
- `--exclude`: Skip certain file patterns or directories