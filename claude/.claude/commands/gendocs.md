---
allowed-tools: Glob, Read, Edit, MultiEdit, Grep, Write
description: Generate comprehensive project documentation and sync README with actual codebase structure and features.
---

## Generate Documentation Command

Analyzes the entire codebase to generate comprehensive documentation and updates the README file to accurately reflect the current state of the project.

### Process:

1. **Codebase Analysis**: 
   - Scan all source files and analyze project structure
   - Identify main entry points, key modules, and dependencies
   - Extract API endpoints, functions, classes, and components
   - Analyze package.json/requirements.txt/etc. for project metadata

2. **Documentation Generation**:
   - **API Documentation**: Auto-generate from code annotations and route definitions
   - **Component Documentation**: Extract props, interfaces, and usage examples
   - **Architecture Overview**: Create project structure diagrams and flow descriptions
   - **Configuration Guide**: Document environment variables, config files, and setup

3. **README Synchronization**:
   - Update project description based on actual functionality
   - Sync installation instructions with current dependencies
   - Update usage examples with real code snippets
   - Refresh feature list based on implemented functionality
   - Update scripts section with actual npm/package scripts
   - Add/update badges for build status, version, etc.

4. **Additional Documentation**:
   - **CONTRIBUTING.md**: Development setup and contribution guidelines
   - **CHANGELOG.md**: Version history and changes (if not exists)
   - **docs/ folder**: Detailed documentation for complex features
   - **examples/ folder**: Working code examples and tutorials

### Features:
- **Smart Content Detection**: Identifies outdated or missing information
- **Live Code Examples**: Extracts real usage patterns from test files
- **Dependency Tracking**: Updates versions and installation commands
- **Multi-format Support**: Generates markdown, HTML, or other formats as needed
- **Template System**: Uses existing README structure as template when possible

### Supported Project Types:
- JavaScript/TypeScript (npm, yarn, pnpm)
- Python (pip, poetry, conda)
- Java (Maven, Gradle)
- Go (go mod)
- Rust (Cargo)
- PHP (Composer)
- .NET (NuGet)

### README Sections Updated:
- **Title & Description**: Based on package.json/project files
- **Installation**: Current dependencies and setup steps
- **Usage**: Real examples from code/tests
- **API Reference**: Extracted from actual implementations
- **Scripts**: Available npm/make/cargo commands
- **Configuration**: Environment variables and config files
- **Contributing**: Development workflow and standards
- **License**: Current license information

### Example Output Structure:
```
README.md (updated)
docs/
├── api/
│   ├── endpoints.md
│   └── authentication.md
├── guides/
│   ├── getting-started.md
│   └── deployment.md
├── architecture/
│   ├── overview.md
│   └── database.md
└── examples/
    ├── basic-usage.js
    └── advanced-features.js
```

### Options:
- `--full`: Generate complete documentation suite
- `--readme-only`: Only update README.md
- `--dry-run`: Show what would be generated without creating files
- `--template`: Use specific documentation template
- `--include-private`: Document internal/private APIs