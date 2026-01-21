______________________________________________________________________

title: Folder Structure

description: Organization and purpose of each directory and file in the LLawn
Neovim configuration

icon: material/folder

______________________________________________________________________

# Folder Structure

This page explains the organization and purpose of each directory and file in
the LLawn Neovim configuration.

## Root Directory Structure

```
~/.config/nvim/
├── .github/               # GitHub Actions workflows
├── .gitignore             # Git ignore file
├── init.lua               # Main entry point
├── lua/
│   └── llawn/             # Main configuration module
├── after/
│   └── lsp/               # LSP server customizations
├── docs/                  # Documentation (MkDocs)
├── scripts/               # Utility scripts
├── mkdocs.yml             # MkDocs configuration
├── lazy-lock.json         # Plugin lock file
├── mason-lock.json        # Mason LSP server lock file
├── treesitter-lock.json   # Treesitter parser lock file
├── LICENSE                # License file
├── Makefile               # Build automation
└── README.md              # Project README
```

## Core Files

### init.lua

**Location**: `~/.config/nvim/init.lua`

**Purpose**: Main Neovim entry point that loads the llawn module

**Contents**:

- ASCII art banner
- Module loading: `require("llawn")`
- Brief comments about configuration switching

### lua/llawn/init.lua

**Location**: `~/.config/nvim/lua/llawn/init.lua`

**Purpose**: Module initialization file

**Contents**:

- Loads the main configuration module
- Single line: `require("llawn.config")`

## Configuration Layer (lua/llawn/config/)

This directory contains the core Neovim configuration, organized by
functionality.

### autocmd.lua

**Purpose**: Autocommands for various Neovim events

**Features**:

- File type specific settings
- Buffer management
- Session handling
- Custom event handling

### globals.lua

**Purpose**: Global variables and constants

**Contents**:

- Configuration constants
- Global settings
- Environment variables

### init.lua

**Purpose**: Configuration initialization and loading

**Contents**:

- Loads all config modules in correct order
- Post-lazy loading setup
- Module dependencies

### keymaps.lua

**Purpose**: Custom key mappings and bindings **Categories**:

- Menu popups
- Navigation (visual line movement)
- Editing (line movement, clipboard)
- File operations
- Lua utilities

### lsp.lua

**Purpose**: Language Server Protocol configuration

**Features**:

- Server enablement using `vim.lsp.enable` with Mason integration
- Language-to-server mapping from Mason registry
- LSP key bindings (buffer-local)
- Diagnostic configuration with floating windows and copy functionality
- Inlay hints setup
- Formatting integration with conform and LSP fallback

### Menu Sub-modules

#### quit.lua

**Purpose**: Quit operations with smart handling of unsaved buffers

**Features**:

- Smart quit logic (checks for unsaved buffers)

- Quit menu with options:

    - **Unsaved Menu**: Interactive handling of unsaved buffers with diff preview
    - **Force Quit**: Quit without saving (`:qa!`)
    - **Save All and Quit**: Save all modified buffers and quit (`:wa` then `:qa`)

#### unsaved.lua

**Purpose**: Interactive handling of unsaved buffers

**Features**:

- Telescope picker listing unsaved buffers

- Diff preview showing changes vs saved file

- Keybindings for operations:

    - `u`: Save selected file
    - `d`: Discard changes for selected file
    - `U`: Save all files
    - `D`: Discard all changes

#### swapfiles.lua

**Purpose**: Swap file management

**Features**:

- Detection and listing of swap files for closed buffers
- Diff preview between saved file and swap content
- Recovery and cleanup options:
    - `r`: Recover selected file
    - `x`: Delete selected swap file
    - `X`: Delete all swap files

#### window.lua

**Purpose**: Window management menu

**Features**:

- **Horizontal Split**: Create horizontal window split
- **Vertical Split**: Create vertical window split
- **Move Left/Right/Up/Down**: Navigate to adjacent windows
- **Close Window**: Close current window

#### git.lua

**Purpose**: Advanced git operations menu

**Features**:

- **Log**: Interactive git log with fuzzy search and filtering by author,
  message, hash, type
- **Diff Menu**: Choose unstaged or staged diff with file-by-file preview
- Async commit data loading
- Browser integration for GitHub/GitLab commits
- Floating windows for full commit diffs
- Syntax highlighting for commit types (feat, fix, docs, etc.)

#### treesitter.lua

**Purpose**: Tree-sitter parser management menu

**Features**:

- **Install/Update/Uninstall**: Manage parser lifecycle with status indicators
- Parser status checking (installed, outdated, not installed)
- Repository URL opening for parsers
- Categorized display: up-to-date, outdated, not installed
- Automatic refresh after operations

#### mason.lua

**Purpose**: LSP server management menu

**Features**:

- **Category Selection**: All, LSP, DAP, Linters, Formatters, Other
- Install/update/uninstall servers with status indicators (✓ installed, ⚠
  outdated, ✗ not installed)
- Package information preview (description, homepage, languages, categories)
- Asynchronous operations with automatic refresh
- Version comparison for outdated packages

### options.lua

**Purpose**: Core Neovim editor options

**Categories**:

- **Line numbering**: Relative + absolute
- **Display**: List chars, wrapping, indentation
- **UI**: Colors, scroll, sign column
- **File handling**: Undo, backups, encoding

### lazy.lua

**Purpose**: Lazy plugin manager configuration

**Contents**:

- Plugin specifications
- Lazy loading setup
- Plugin dependencies

## Utilities Layer (lua/llawn/utils/)

This directory contains utility functions and modules used across the
configuration.

### diff.lua

**Purpose**: Diff-related utilities

**Features**:

- Diff computation and display functions

### lockfile.lua

**Purpose**: Lock file management utilities

**Features**:

- Lock file operations and handling

### menu.lua

**Purpose**: Menu utility functions

**Features**:

- Menu creation and management helpers

### mason.lua

**Purpose**: Mason package management utilities

**Features**:

- Bridge Mason language names to Neovim filetypes
- Get installed Mason tools by category (LSP, Linter, Formatter)
- Filter tools based on categories and languages

### formatting.lua

**Purpose**: Formatting utilities for LSP and conform integration

**Features**:

- Confirmation-based formatting with diff preview
- Prioritizes conform formatters over LSP
- Handles both conform and LSP formatting workflows

## Plugin Layer (lua/llawn/plugins/)

Each plugin has its own configuration file for modularity.

### LSP Plugins (lsp/)

#### cmp-nvim-lsp.lua

**Purpose**: LSP completion integration for nvim-cmp

**Dependencies**:

- `nvim-lsp-file-operations`
- `lazydev.nvim`

**Features**:

- Enhanced completion capabilities
- File operations handling

#### mason.lua

**Purpose**: LSP server management

**Configuration**:

- Auto-installation list
- UI settings with icons
- Server status indicators

#### conform.lua

**Purpose**: Code formatting with conform.nvim

**Features**:

- Automatic formatter detection from Mason
- Manual formatting with confirmation and diff preview
- LSP fallback formatting
- Format-on-save disabled by default

#### linting.lua

**Purpose**: Asynchronous linting with nvim-lint

**Features**:

- Automatic linter detection from Mason
- Filters out linters that are also LSP servers
- Runs on buffer events (enter, write, insert leave)
- Manual lint trigger

### Core Plugins

#### colors.lua

**Purpose**: Theme configuration (Rose Pine)

**Features**:

- Moon variant setup
- Transparent background
- Custom highlight groups
- Invisible character styling

#### gitsigns.lua

**Purpose**: Git signs and hunk management

**Features**:

- Git change indicators in sign column
- Hunk navigation and staging
- Blame information

#### alpha.lua

**Purpose**: Startup dashboard

**Features**:

- Custom dashboard layout
- Quick access to recent files

#### treesitter.lua

**Purpose**: Tree-sitter syntax highlighting

**Features**:

- Parser installation
- Highlighting configuration

#### harpoon.lua

**Purpose**: Quick file navigation

**Features**:

- Persistent file marks
- Fast switching

#### lexima.lua

**Purpose**: Auto-pairing plugin

**Features**:

- Automatic bracket and quote pairing
- Smart pairing logic

#### llawn-colors.lua

**Purpose**: Custom color utilities and database

**Features**:

- Color name to hex mapping
- Color picker integration
- Virtual text hints for colors

#### lazygit.lua

**Purpose**: Git integration

**Features**:

- Floating window
- Terminal integration
- GPG support

#### lualine.lua

**Purpose**: Status line enhancement

**Features**:

- LSP status display
- Git integration
- File information
- Custom sections with icons

#### neogen.lua

**Purpose**: Documentation generation

**Dependencies**:

- `nvim-treesitter`
- `LuaSnip`

#### render-markdown.lua

**Purpose**: Markdown rendering in Neovim

**Features**:

- Syntax highlighting for markdown
- Code block rendering

#### nvim-cmp.lua

**Purpose**: Code completion engine

**Features**:

- Multiple completion sources
- Snippet support
- Smart selection

#### telescope.lua

**Purpose**: Fuzzy finder and search

**Features**:

- File/buffer search
- Live grep
- Help system integration

#### undotree.lua

**Purpose**: Visual undo history

**Features**:

- Branch visualization
- Time-based navigation

#### vim-be-good.lua

**Purpose**: Vim practice game

**Features**:

- Interactive Vim training exercises

#### which-key.lua

**Purpose**: Key binding hints

**Features**:

- Interactive help
- Key combination display
- Grouped mappings

#### yazi.lua

**Purpose**: File manager integration

**Features**:

- Floating window
- Directory replacement
- Terminal integration

## LSP Customizations (after/lsp/)

### flutter_ls.lua

**Purpose**: Custom Flutter/Dart LSP configuration

**Features**:

- Custom command using analysis server
- Enhanced Flutter features
- Project detection via `pubspec.yaml`

### lua_ls.lua

**Purpose**: Custom Lua LSP configuration

**Features**:

- Lua language server settings
- Custom diagnostics and hints

### ruff.lua

**Purpose**: Custom Ruff linter configuration

**Features**:

- Python linting with Ruff
- Integration with LSP

## Extension Points

### Adding New Features

1. **Config**: Add to `lua/llawn/config/`
2. **Plugins**: Create in `lua/llawn/plugins/`
3. **LSP**: Add to `after/lsp/` for custom servers
4. **Documentation**: Update relevant `.md` files

### Customization

- **Keymaps**: Modify `keymaps.lua`
- **Options**: Edit `options.lua`
- **Theme**: Adjust `colors.lua`
- **Plugins**: Add new plugin files

This modular structure ensures maintainability, easy navigation, and clear
separation of concerns throughout the configuration.
