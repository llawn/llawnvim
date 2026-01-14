---

title: Keymaps

description: Complete reference of all key mappings in the LLawn Neovim configuration

icon: material/keyboard

---

# Keymaps

This page provides a comprehensive reference of all key mappings in the LLawn Neovim configuration, organized by category and functionality.

## Legend

- **Mode**: `n` (normal), `i` (insert), `v` (visual), `x` (visual block), `t` (terminal)
- **Key**: The key combination
- **Description**: What the mapping does

## Popup Menus

| Key | Mode | Description |
|-----|------|-------------|
| `<C-w>` | n | Window popup menu (split, move, close) |
| `<C-g>` | n | Git popup menu (status, commit, push, log, diff) |
| `<C-t>` | n | Treesitter popup menu (parser management) |
| `<A-m>` | n | Mason popup menu (server management) |

### Window Operations

| Key | Mode | Description |
|-----|------|-------------|
| `<C-w>1` | n | Horizontal split |
| `<C-w>2` | n | Vertical split |
| `<C-w>3` | n | Move to left window |
| `<C-w>4` | n | Move to right window |
| `<C-w>5` | n | Move to upper window |
| `<C-w>6` | n | Move to lower window |
| `<C-w>7` | n | Close current window |

### Git Operations

| Key | Mode | Description |
|-----|------|-------------|
| `<C-g>1` | n | Git Status |
| `<C-g>2` | n | Git Commit |
| `<C-g>3` | n | Git Push |
| `<C-g>4` | n | Git Log |
| `<C-g>5` | n | Git Diff |

## Editing

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
| `<leader>q` | n | Smart quit (opens quit menu if unsaved buffers exist) |

### Quit Operations

The quit system provides intelligent handling of unsaved files:

- **Smart Quit**: If no unsaved buffers, quits immediately; otherwise opens quit menu
- **Quit Menu Options**:
  - Unsaved Menu: Interactive handling of unsaved buffers with diff preview
  - Force Quit: Quit without saving
  - Save All and Quit: Save all modified buffers and quit

#### Unsaved Buffers Menu

When unsaved buffers exist, a Telescope picker shows:

- **u**: Save selected file
- **d**: Discard changes for selected file
- **U**: Save all files
- **D**: Discard all changes

Each entry shows a diff preview of unsaved changes.

## File Management

### Explorer

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>x` | n | Open file explorer (Yazi if configure) |
| `<leader>-` | n,v | Open Yazi at current file |
| `<leader>cw` | n | Open Yazi in current working directory |
| `<c-up>` | n | Resume last Yazi session |

### Yazi Integration

| Key | Mode | Description |
|-----|------|-------------|
| `<c-l>` | t | Open LazyGit from Yazi |
| `<c-x>` | t | Quit LazyGit to Yazi |

## Navigation

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

## LSP (Language Server Protocol)

### Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gi` | n | Go to implementations |
| `gR` | n | Show references |
| `gt` | n | Go to type definitions |

### Code Actions

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ca` | n,v | Code actions |
| `<leader>rn` | n | Rename symbol |

### Diagnostics

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>d` | n | Show line diagnostics |
| `<leader>D` | n | Show buffer diagnostics |
| `[d` | n | Previous diagnostic |
| `]d` | n | Next diagnostic |

### Documentation

| Key | Mode | Description |
|-----|------|-------------|
| `K` | n | Show documentation on hover |
| `<leader>rs` | n | Restart LSP |

## Treesitter

### Syntax Tree Inspection

| Key | Mode | Description |
|-----|------|-------------|
| `<C-t>` | n | Treesitter parser management menu |
| `<leader>tp` | n | Open treesitter playground (InspectTree) |
| `<leader>tl` | n | Toggle treesitter highlight for buffer |

### Parser Management

| Key | Mode | Description |
|-----|------|-------------|
| `I` | i | Install selected parser (in Treesitter menu) |
| `X` | i | Uninstall selected parser (in Treesitter menu) |
| `U` | i | Update selected parser (in Treesitter menu) |

### Text Objects

| Key | Mode | Description |
|-----|------|-------------|
| `af` | v | Select around function |
| `if` | v | Select inner function |
| `ac` | v | Select around class |
| `ic` | v | Select inner class |
| `al` | v | Select around loop |
| `il` | v | Select inner loop |
| `aa` | v | Select around parameter |
| `ia` | v | Select inner parameter |
| `ab` | v | Select around block |
| `ib` | v | Select inner block |
| `ai` | v | Select around conditional |
| `ii` | v | Select inner conditional |
| `as` | v | Select around statement |
| `is` | v | Select inner statement |
| `am` | v | Select around call |
| `im` | v | Select inner call |

### Movement

| Key | Mode | Description |
|-----|------|-------------|
| `]f` | n | Next function start |
| `]c` | n | Next class start |
| `]l` | n | Next loop start |
| `]a` | n | Next parameter start |
| `]b` | n | Next block start |
| `]i` | n | Next conditional start |
| `]s` | n | Next statement start |
| `]m` | n | Next call start |
| `]F` | n | Next function end |
| `]C` | n | Next class end |
| `]L` | n | Next loop end |
| `]A` | n | Next parameter end |
| `]B` | n | Next block end |
| `]I` | n | Next conditional end |
| `]S` | n | Next statement end |
| `]M` | n | Next call end |
| `[f` | n | Previous function start |
| `[c` | n | Previous class start |
| `[l` | n | Previous loop start |
| `[a` | n | Previous parameter start |
| `[b` | n | Previous block start |
| `[i` | n | Previous conditional start |
| `[s` | n | Previous statement start |
| `[m` | n | Previous call start |
| `[F` | n | Previous function end |
| `[C` | n | Previous class end |
| `[L` | n | Previous loop end |
| `[A` | n | Previous parameter end |
| `[B` | n | Previous block end |
| `[I` | n | Previous conditional end |
| `[S` | n | Previous statement end |
| `[M` | n | Previous call end |

### Incremental Selection

| Key | Mode | Description |
|-----|------|-------------|
| `gnn` | n | Start incremental selection |
| `grn` | n,v | Increment selection to next node |
| `grc` | n,v | Increment selection to next scope |
| `grm` | n,v | Decrement selection to previous node |

### Swap

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sp` | n | Swap next parameter |
| `<leader>sP` | n | Swap previous parameter |

## Mason

### LSP Server Management

| Key | Mode | Description |
|-----|------|-------------|
| `<A-m>` | n | Open Mason telescope menu for server management |
| `I` | i | Install selected server (in Mason menu) |
| `X` | i | Uninstall selected server (in Mason menu) |
| `U` | i | Update selected server (in Mason menu) |

## Development Tools

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
| `<leader>cc` | n | Open 2D grid color picker |
| `<leader>tc` | n | Open Telescope color picker |
| `<leader>ct` | n | Toggle color highlights |

### Undo Management

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>u` | n | Toggle UndoTree |

## Lua Development

### Code Execution
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>s` | n | Source current file |
| `<leader>lx` | n | Execute current line (Lua) |
| `<leader>lx` | v | Execute selection (Lua) |

## UI Toggles

### Display Options
| Key | Mode | Description |
|-----|------|-------------|
| `<C-l>` | n | Toggle list characters |

## Custom Keymap Groups

### Leader Key (`<leader>`)

The leader key is set to ` ` (whitespace) by default.
All `<leader>` mappings use this prefix.

### Control Key Combinations

- `<C-w>`: Window operations
- `<C-g>`: Git operations
- `<C-t>`: Tree-sitter operations
- `<C-l>`: UI toggles listchars
- `<C-q>`: Visual block mode
- `<C-c/x/v>`: System clipboard
- `<C-a/z/y>`: File operations
- `<C-s>`: Save file

### Alt Key Combinations

- `<A-k/j>`: Move lines up/down

### Special Modes

- **Terminal Mode**: `<c-l>`, `<c-x>` for Yazi/LazyGit switching

## Customization

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
