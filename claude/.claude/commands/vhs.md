---
allowed-tools: Glob, Read, Edit, MultiEdit, Write, Bash, Grep
description: Generate VHS terminal recordings and GIFs for project demonstrations using charmbracelet/vhs
bash-timeout: 600000
---

## VHS Demo Generator Command

Creates professional terminal recordings and GIFs using [VHS](https://github.com/charmbracelet/vhs) to showcase CLI tools, project features, and installation processes. Automatically integrates generated GIFs into project README files.

### Process:

1. **Project Analysis**:
   - Detect project type (CLI tool, web app, library, etc.)
   - Analyze package.json, Cargo.toml, or other config files
   - Identify main entry points and key features
   - Check for existing documentation and demos

2. **Script Generation**:
   - **CLI Tools**: Demo installation, basic usage, and key features
   - **Web Applications**: Show development server startup and key features
   - **Libraries**: Demonstrate API usage with examples
   - **Documentation Sites**: Show build process and navigation
   - **General Projects**: Create overview of project structure and setup

3. **VHS Tape Creation**:
   - Generate `.tape` files with appropriate terminal commands
   - Configure optimal settings (window size, timing, theme)
   - Include realistic typing delays and pauses
   - Add descriptive comments and clear demonstrations

4. **GIF Generation**:
   - Run VHS to create high-quality GIF recordings
   - Optimize file size while maintaining quality
   - Place GIFs in appropriate directory (usually `assets/`, `docs/`, or root)
   - Generate multiple versions if needed (overview, installation, usage)

5. **README Integration**:
   - Automatically detect and parse existing README.md
   - Insert GIF references in appropriate sections
   - Create new sections if needed (Demo, Usage, Installation)
   - Maintain existing formatting and structure

### Project Type Detection:

**CLI Tools:**
- package.json with `bin` field
- Cargo.toml with `[[bin]]` sections
- Go projects with `main.go`
- Python projects with CLI entry points

**Web Applications:**
- React, Vue, Angular, Svelte projects
- Express, FastAPI, Django applications
- Static site generators (Next.js, Gatsby, etc.)

**Libraries/SDKs:**
- NPM packages without bin field
- Rust crates (library type)
- Python packages with public APIs

**Documentation:**
- Projects with docs/ folders
- Gitbook, VuePress, Docusaurus setups

### Generated VHS Scripts:

**CLI Tool Example:**
```tape
Output demo-cli.gif

Set FontSize 14
Set Width 1200
Set Height 600
Set Theme "Dracula"

Type "npm install -g awesome-cli"
Enter
Sleep 3s

Type "awesome-cli --help"
Enter
Sleep 2s

Type "awesome-cli generate --name myproject"
Enter
Sleep 3s

Type "ls -la"
Enter
Sleep 2s
```

**Web App Example:**
```tape
Output demo-webapp.gif

Set FontSize 14
Set Width 1400
Set Height 800
Set Theme "Tokyo Night"

Type "bun install"
Enter
Sleep 3s

Type "bun run dev"
Enter
Sleep 5s

Type "# Navigate to http://localhost:3000"
Sleep 3s
```

### README Integration Patterns:

**CLI Tools:**
```markdown
## Demo

![CLI Demo](./assets/demo-cli.gif)

## Installation

```bash
npm install -g your-cli-tool
```

## Usage

![Usage Demo](./assets/demo-usage.gif)
```

**Web Applications:**
```markdown
## Quick Start

![Getting Started](./docs/demo-quickstart.gif)

### Development

```bash
bun install
bun run dev
```

## Features

![Features Demo](./docs/demo-features.gif)
```

### File Organization:

```
project-root/
├── assets/           # For CLI tools and libraries
│   ├── demo.gif
│   ├── installation.gif
│   └── usage.gif
├── docs/             # For larger projects
│   ├── images/
│   │   ├── demo.gif
│   │   └── features.gif
│   └── demo.tape
├── scripts/          # VHS tape files
│   ├── demo.tape
│   ├── install.tape
│   └── usage.tape
└── README.md         # Updated with GIF references
```

### VHS Configuration Options:

**Themes:** Dracula, Tokyo Night, Nord, Monokai, Solarized
**Sizes:** Small (800x600), Medium (1200x800), Large (1600x1000)
**Quality:** High quality with optimized file sizes
**Timing:** Natural typing speeds with appropriate pauses

### Supported Scenarios:

1. **Installation Demos**: Package managers, setup steps
2. **Feature Showcases**: Key functionality and options
3. **Workflow Demonstrations**: Typical user journeys
4. **Error Handling**: Common issues and solutions
5. **Configuration Examples**: Setup and customization

### Generated Assets:

- **VHS Tape Files**: Reusable scripts for regenerating GIFs
- **Optimized GIFs**: Web-ready with reasonable file sizes
- **Multiple Variants**: Different aspects (installation, usage, features)
- **README Integration**: Automatic placement in appropriate sections

### Options:
- `--type cli|webapp|library|docs`: Force specific project type
- `--theme THEME`: Set VHS theme (default: auto-detect)
- `--size WxH`: Set recording dimensions
- `--output DIR`: Specify output directory for GIFs
- `--no-readme`: Skip README integration
- `--dry-run`: Generate tape files without creating GIFs
- `--overwrite`: Replace existing GIFs and README sections

### Prerequisites:
- VHS must be installed (`go install github.com/charmbracelet/vhs@latest`)
- Project should have clear entry points or documentation
- Terminal should support the chosen theme

### Performance Notes:
- VHS GIF generation can take several minutes for complex recordings
- Commands are configured with extended timeouts (10 minutes) to handle long-running VHS processes
- Large or complex terminal recordings may require additional processing time
- Consider using `--dry-run` for testing tape files before full GIF generation

### Quality Guidelines:
- Keep recordings under 30 seconds when possible
- Show realistic typing speeds (not too fast)
- Include brief pauses to let users read output
- Use clear, descriptive commands
- Avoid sensitive information in demos
- Test commands before recording
