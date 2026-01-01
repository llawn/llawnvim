```markdown
   ██╗     ██╗      █████╗ ██╗    ██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
   ██║     ██║     ██╔══██╗██║    ██║████╗  ██║██║   ██║██║████╗ ████║
   ██║     ██║     ███████║██║ █╗ ██║██╔██╗ ██║██║   ██║██║██╔████╔██║
   ██║     ██║     ██╔══██║██║███╗██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ███████╗███████╗██║  ██║╚███╔███╔╝██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚══════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
```
---

![GitHub License](https://img.shields.io/github/license/llawn/nvimconfig)
![GitHub repo size](https://img.shields.io/github/repo-size/llawn/nvimconfig)
![GitHub Tag](https://img.shields.io/github/v/tag/llawn/nvimconfig)

# LLawn Neovim Configuration

My personal Neovim configuration, modular and optimized for multiple languages:

- C / C++ (clangd)
- Flutter / Dart (flutter_ls)
- Fortran (fortls)
- Go (gopls)
- Lua (lua_ls)
- Python (ty, ruff)

## Features

- **Lazy** plugin manager for fast startup.
- Built-in **LSP setup** using Neovim 0.11+ `vim.lsp.enable`.
- **Keymaps and menus** for window management, Git, and more.
- **Diagnostics** with virtual lines and navigation.
- Plugins configured: Harpoon, Lualine, Telescope, UndoTree, WhichKey, Yazi.

## Folder Structure

```
lua/llawn/
├─ config/    → LSP setups, keymaps, menus, autocmds, options
└─ plugins/   → Plugin configurations (Harpoon, Lualine, Telescope, etc.)
```

- `.config/nvim/lsp/` contains individual server configs
  (`clangd.lua`, `ty.lua`, etc.)
- `.config/nvim/lua/llawn/config/`:
  - centralizes LSP enable calls
  - keymaps
  - options
  - ...
- `.config/nvim/lua/llawn/plugins/` holds plugin setups.

## Installation

1. Clone this repository:

```bash
git clone git@github.com:llawn/nvimconfig.git
```

2. Install plugins using Lazy:

```vim
:Lazy sync
```

3. Open Neovim and enjoy your fully configured setup.

## Usage

* **Load the configuration**:

```lua
require("llawn")
```

* **LSP keymaps**:

  * `K` → Hover
  * `gd` → Go to definition
  * `gi` → Go to implementation
  * `<leader>ca` → Code actions
  * `[d` / `]d` → Previous/Next diagnostic
  * `<leader>d` → Open diagnostic list

* **Completion**:

  * `<C-Space>` → Trigger completion
  * `<CR>` → Confirm selection
  * `<Tab>` / `<S-Tab>` → Navigate items and snippets

* **Menus**:

  * `<C-w>` → Window menu
  * `<C-g>` → Git menu

---

This configuration is continuously updated and modular, making it easy to
expand with new languages or plugins.
