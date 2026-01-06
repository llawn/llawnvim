# Folder Structure

This page explains the organization and purpose of each directory and file in the LLawn Neovim configuration.

## 📁 Root Directory Structure

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/
│   └── llawn/              # Main configuration module
├── after/
│   └── lsp/                # LSP server customizations
├── docs/                   # Documentation (MkDocs)
├── mkdocs.yml             # MkDocs configuration
├── lazy-lock.json         # Plugin lock file
├── LICENSE                # License file
├── Makefile               # Build automation
└── README.md              # Project README
```

## 🏗️ Core Files

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

## ⚙️ Configuration Layer (lua/llawn/config/)

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
- Window management (`<C-w>`, `<C-g>`)
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

## 🔌 Plugin Layer (lua/llawn/plugins/)

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

#### ccc.lua
**Purpose**: Color picker and highlighter
**Keymaps**:
- `<leader>cc`: Open color picker
- `<leader>ct`: Toggle highlighter
**Features**:
- Color manipulation
- LSP integration
- Auto-enable highlighter

#### colors.lua
**Purpose**: Theme configuration (Rose Pine)
**Features**:
- Moon variant setup
- Transparent background
- Custom highlight groups
- Invisible character styling

#### harpoon.lua
**Purpose**: Quick file navigation
**Keymaps**:
- `<leader>a`: Add file
- `<C-e>`: Quick menu
- `<C-1/2/3>`: Select files
**Features**:
- Persistent file marks
- Fast switching

#### lazygit.lua
**Purpose**: Git integration
**Keymaps**:
- `<leader>lg`: Launch LazyGit
- `<c-x>` (terminal): Quit to Yazi
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
**Keymaps**:
- `<leader>nf`: Function docs
- `<leader>nt`: Type docs

#### nvim-cmp.lua
**Purpose**: Code completion engine
**Features**:
- Multiple completion sources
- Snippet support
- Smart selection

#### telescope.lua
**Purpose**: Fuzzy finder and search
**Keymaps**:
- `<leader>tf`: Find files
- `<leader>tg`: Git files
- `<leader>tb`: Buffers
- `<leader>th`: Help
- `<leader>tw`: Find word
**Features**:
- File/buffer search
- Live grep
- Help system integration

#### undotree.lua
**Purpose**: Visual undo history
**Keymaps**:
- `<leader>u`: Toggle tree
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
**Keymaps**:
- `<leader>-`: Open at file
- `<leader>cw`: Open in cwd
- `<c-up>`: Resume session
- `<c-l>` (Yazi): Switch to LazyGit
**Features**:
- Floating window
- Directory replacement
- Terminal integration

## 🔧 LSP Customizations (after/lsp/)

### flutter_ls.lua
**Purpose**: Custom Flutter/Dart LSP configuration
**Requirements**:
- `FLUTTER_ROOT` environment variable
- Flutter SDK path detection
**Features**:
- Custom command using analysis server
- Enhanced Flutter features
- Project detection via `pubspec.yaml`

## 📚 Documentation (docs/)

### index.md
**Purpose**: Home page with overview and quick start
**Contents**:
- ASCII art banner
- Feature highlights
- Installation summary
- Navigation links

### features.md
**Purpose**: Detailed feature documentation
**Sections**:
- Architecture overview
- Language support
- UI/UX features
- Development tools

### plugins.md
**Purpose**: Plugin configurations and usage
**Contents**:
- Plugin manager (Lazy)
- Core plugins with details
- Configuration options
- Version information

### lsp.md
**Purpose**: LSP setup and language configurations
**Contents**:
- Server management
- Language-specific setup
- Key bindings
- Troubleshooting

### keymaps.md
**Purpose**: Complete key mapping reference
**Organization**:
- By functionality
- Mode indicators
- Descriptions

### installation.md
**Purpose**: Setup and installation guide
**Contents**:
- Prerequisites
- Installation methods
- Language setup
- Troubleshooting

### structure.md
**Purpose**: This file - directory explanations

## 🛠️ Build and Automation

### Makefile
**Purpose**: Build automation for documentation
**Commands**:
- Build MkDocs site
- Serve documentation locally
- Deploy documentation

### lazy-lock.json
**Purpose**: Plugin version locking
**Generated by**: Lazy plugin manager
**Contents**: Exact plugin commits for reproducibility

### mkdocs.yml
**Purpose**: MkDocs configuration
**Features**:
- Material theme with dark/light toggle
- Navigation structure
- Site metadata

## 📄 Project Files

### README.md
**Purpose**: Project overview and quick reference
**Contents**:
- Description
- Installation
- Features
- Contributing

### LICENSE
**Purpose**: Legal license information
**Type**: MIT License

## 🔍 File Naming Conventions

### Configuration Files
- **snake_case**: `keymaps.lua`, `lsp.lua`
- **Descriptive names**: Clear purpose indication

### Plugin Files
- **Plugin name**: `telescope.lua`, `harpoon.lua`
- **Subdirectories**: `lsp/cmp-nvim-lsp.lua`

### Documentation
- **Lowercase**: `features.md`, `installation.md`
- **Descriptive**: Purpose-clear names

## 🚀 Extension Points

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