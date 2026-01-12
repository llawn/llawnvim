---

title: Folder Structure

description: Organization and purpose of each directory and file in the LLawn Neovim configuration

icon: material/folder

---

# Folder Structure

This page explains the organization and purpose of each directory and file in the LLawn Neovim configuration.

## Root Directory Structure

```
~/.config/nvim/
├── init.lua               # Main entry point
├── lua/
│   └── llawn/             # Main configuration module
├── after/
│   └── lsp/               # LSP server customizations
├── docs/                  # Documentation (MkDocs)
├── mkdocs.yml             # MkDocs configuration
├── lazy-lock.json         # Plugin lock file
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

This directory contains the core Neovim configuration, organized by functionality.

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

**Purpose**: Custom key mappings and bindings
**Categories**:

- Menu popups
- Navigation (visual line movement)
- Editing (line movement, clipboard)
- File operations
- Lua utilities

### lsp.lua

**Purpose**: Language Server Protocol configuration

**Features**:
- Server enablement using `vim.lsp.enable`
- Language-to-server mapping
- LSP key bindings (buffer-local)
- Diagnostic configuration
- Inlay hints setup

### menu.lua

**Purpose**: Interactive popup menus

**Menus**:

- **Window Menu**: Split management, navigation
- **Git Menu**: Status, commit, push, log, diff
- UI selection with `vim.ui.select`

### options.lua

**Purpose**: Core Neovim editor options

**Categories**:

- **Line numbering**: Relative + absolute
- **Display**: List chars, wrapping, indentation
- **UI**: Colors, scroll, sign column
- **File handling**: Undo, backups, encoding

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

### Core Plugins

#### colors.lua

**Purpose**: Theme configuration (Rose Pine)

**Features**:

- Moon variant setup
- Transparent background
- Custom highlight groups
- Invisible character styling

#### harpoon.lua

**Purpose**: Quick file navigation

**Features**:

- Persistent file marks
- Fast switching

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

### Local Plugins (local/)

Custom local plugins not managed by Lazy.

#### colors.lua

**Purpose**: Color database with names and hex values

**Contents**:
- Comprehensive color palette (500+ colors)
- Name-to-hex mapping for easy lookup

#### telescope_color_picker.lua

**Purpose**: Custom color picker using Telescope

**Features**:
- Fuzzy search by color name
- Hex code proximity matching
- Visual swatches and contrast previews
- Integration with nvim-cmp for color completion
- `:HexColors` command for interactive selection

#### grid_color_picker.lua

**Purpose**: 2D grid color picker with HSL sorting

**Features**:
- Grid display sorted by HSL for perceptual uniformity
- Hover info for color names and hex codes
- Enter key to insert selected color
- `:ColorPick2D` command for interactive selection

## LSP Customizations (after/lsp/)

### flutter_ls.lua

**Purpose**: Custom Flutter/Dart LSP configuration

**Features**:
- Custom command using analysis server
- Enhanced Flutter features
- Project detection via `pubspec.yaml`

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

This modular structure ensures maintainability, easy navigation, and clear separation of concerns throughout the configuration.
