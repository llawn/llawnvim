# Keymaps

This page provides a comprehensive reference of all key mappings in the LLawn Neovim configuration, organized by category and functionality.

## 🎯 Legend

- **Mode**: `n` (normal), `i` (insert), `v` (visual), `x` (visual block), `t` (terminal)
- **Key**: The key combination
- **Description**: What the mapping does

## 🪟 Window Management

### Popup Menus
| Key | Mode | Description |
|-----|------|-------------|
| `<C-w>` | n | Window popup menu (split, move, close) |
| `<C-g>` | n | Git popup menu (status, commit, push, log, diff) |

### Window Operations
| Key | Mode | Description |
|-----|------|-------------|
| `<C-w>s` | n | Horizontal split (via menu) |
| `<C-w>v` | n | Vertical split (via menu) |
| `<C-w>h` | n | Move to left window (via menu) |
| `<C-w>l` | n | Move to right window (via menu) |
| `<C-w>k` | n | Move to upper window (via menu) |
| `<C-w>j` | n | Move to lower window (via menu) |
| `<C-w>c` | n | Close current window (via menu) |

## 🔧 Editing

### Navigation
| Key | Mode | Description |
|-----|------|-------------|
| `j` | n,x | Move cursor down (visual line) |
| `k` | n,x | Move cursor up (visual line) |
| `<Down>` | n,x,i | Move cursor down (visual line) |
| `<Up>` | n,x,i | Move cursor up (visual line) |

### Text Manipulation
| Key | Mode | Description |
|-----|------|-------------|
| `<C-q>` | n | Enter Visual Block mode |
| `<A-k>` | n,i,v | Move current line/selection up |
| `<A-j>` | n,i,v | Move current line/selection down |
| `<C-c>` | x | Copy selection to system clipboard |
| `<C-x>` | x | Cut selection to system clipboard |
| `<C-v>` | n,i,x | Paste from system clipboard |
| `<C-a>` | n | Select all text |
| `<C-z>` | n | Undo |
| `<C-y>` | n | Redo |

### File Operations
| Key | Mode | Description |
|-----|------|-------------|
| `<C-s>` | n,i,v | Save current file |
| `<leader>w` | n | Save current file |
| `<leader>q` | n | Quit Neovim |

## 📂 File Management

### Explorer
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>x` | n | Open file explorer (Yazi or netrw) |
| `<leader>-` | n,v | Open Yazi at current file |
| `<leader>cw` | n | Open Yazi in current working directory |
| `<c-up>` | n | Resume last Yazi session |

### Yazi Integration
| Key | Mode | Description |
|-----|------|-------------|
| `<c-l>` | t | Open LazyGit from Yazi |
| `<c-x>` | t | Quit LazyGit to Yazi |

## 🧭 Navigation

### Buffer Management
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>bb` | n | Switch to alternate buffer |
| `<leader>bn` | n | Next buffer |
| `<leader>bp` | n | Previous buffer |

### Harpoon (Quick File Navigation)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>a` | n | Add current file to Harpoon list |
| `<C-e>` | n | Toggle Harpoon quick menu |
| `<C-1>` | n | Select Harpoon file 1 |
| `<C-2>` | n | Select Harpoon file 2 |
| `<C-3>` | n | Select Harpoon file 3 |

### Telescope (Fuzzy Finder)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>tf` | n | Find files |
| `<leader>tg` | n | Find git files |
| `<leader>tb` | n | Browse buffers |
| `<leader>th` | n | Search help tags |
| `<leader>tw` | n | Find word under cursor |

## 🔍 LSP (Language Server Protocol)

### Navigation
| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gR` | n | Show references |
| `gi` | n | Go to implementations |
| `gt` | n | Go to type definitions |
| `gD` | n | Go to declaration |

### Code Actions
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ca` | n,v | Code actions |
| `<leader>rn` | n | Rename symbol |

### Diagnostics
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>D` | n | Show buffer diagnostics |
| `<leader>d` | n | Show line diagnostics |
| `[d` | n | Previous diagnostic |
| `]d` | n | Next diagnostic |

### Documentation
| Key | Mode | Description |
|-----|------|-------------|
| `K` | n | Show documentation on hover |
| `<leader>rs` | n | Restart LSP |

## 🛠️ Development Tools

### Git Integration
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>lg` | n | Open LazyGit |
| `<C-g>` | n | Git popup menu |

### Documentation Generation
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>nf` | n | Generate function docstring |
| `<leader>nt` | n | Generate type/class docstring |

### Color Tools
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>cc` | n | Open color picker |
| `<leader>ct` | n | Toggle color highlighter |

### Undo Management
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>u` | n | Toggle UndoTree |

## 🔧 Lua Development

### Code Execution
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>s` | n | Source current file |
| `<leader>lx` | n | Execute current line (Lua) |
| `<leader>lx` | v | Execute selection (Lua) |

## 👁️ UI Toggles

### Display Options
| Key | Mode | Description |
|-----|------|-------------|
| `<C-l>` | n | Toggle list characters |

## 📋 Menu Options

### Window Menu (`<C-w>`)
- **Horizontal Split**: Create horizontal split
- **Vertical Split**: Create vertical split
- **Move Left/Right/Up/Down**: Navigate between windows
- **Close Window**: Close current window

### Git Menu (`<C-g>`)
- **Git Status**: Show repository status
- **Git Commit**: Commit changes
- **Git Push**: Push to remote
- **Git Log**: Show commit history
- **Git Diff**: Show changes

## 🎨 Custom Keymap Groups

### Leader Key (`<leader>`)
The leader key is set to `\` (backslash) by default. All `<leader>` mappings use this prefix.

### Control Key Combinations
- `<C-w>`: Window operations
- `<C-g>`: Git operations
- `<C-l>`: UI toggles
- `<C-q>`: Visual block mode
- `<C-c/x/v>`: System clipboard
- `<C-a/z/y>`: File operations
- `<C-s>`: Save file

### Alt Key Combinations
- `<A-k/j>`: Move lines up/down

### Special Modes
- **Terminal Mode**: `<c-l>`, `<c-x>` for Yazi/LazyGit switching
- **Insert Mode**: Arrow keys for visual line movement
- **Visual Modes**: Enhanced navigation and clipboard operations

## ⚙️ Customization

### Adding Keymaps
Keymaps are defined in `lua/llawn/config/keymaps.lua`. To add new mappings:

```lua
vim.keymap.set("n", "<leader>your_key", your_command, { desc = "Description" })
```

### Menu Customization
Menus are defined in `lua/llawn/config/menu.lua`. Add new menu items:

```lua
{
  "Menu Item",
  function() vim.cmd("YourCommand") end
}
```

### Plugin Keymaps
Plugin-specific keymaps are defined in their respective configuration files in `lua/llawn/plugins/`.

This comprehensive keymap system provides efficient, mnemonic access to all Neovim functionality while maintaining discoverability through Which-Key integration.