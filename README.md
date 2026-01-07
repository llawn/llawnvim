```markdown
   ██╗     ██╗      █████╗ ██╗    ██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
   ██║     ██║     ██╔══██╗██║    ██║████╗  ██║██║   ██║██║████╗ ████║
   ██║     ██║     ███████║██║ █╗ ██║██╔██╗ ██║██║   ██║██║██╔████╔██║
   ██║     ██║     ██╔══██║██║███╗██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ███████╗███████╗██║  ██║╚███╔███╔╝██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚══════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
```
---

![GitHub License](https://img.shields.io/github/license/llawn/llawnvim)
![GitHub repo size](https://img.shields.io/github/repo-size/llawn/llawnvim)
![GitHub Tag](https://img.shields.io/github/v/tag/llawn/llawnvim)
![Neovim Version](https://img.shields.io/badge/Neovim-0.11+-57A143)
[![MkDocs](https://img.shields.io/badge/docs-mkdocs-blue)](https://llawn.github.io/llawnvim/)

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
- **Mason** for automatic LSP server installation.
- Built-in **LSP setup** using Neovim 0.11+ `vim.lsp.enable`.
- **Keymaps and menus** for window management, Git, and more.
- Plugins configured:

| Plugin | Description | Version |
|--------|-------------|---------|
| [rose-pine](https://github.com/rose-pine/neovim) | Color scheme | cf2a288 |
| [ccc](https://github.com/uga-rosa/ccc.nvim) | Color picker and highlighter | 9d1a256 |
| [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2) | File navigation | 87b1a35 |
| [lazygit](https://github.com/kdheepak/lazygit.nvim) | Git integration | a04ad0d |
| [lualine](https://github.com/nvim-lualine/lualine.nvim) | Status line | 47f91c4 |
| [neogen](https://github.com/danymat/neogen) | Documentation generation | d7f9461 |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine | 85bbfad |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion integration | cbc7b02 |
| [mason](https://github.com/williamboman/mason.nvim) | LSP server manager | 57e5a8a |
| [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) | Mason LSP bridge | 4cfe411 |
| [telescope](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder | 3333a52 |
| [undotree](https://github.com/mbbill/undotree) | Undo tree | 178d19e |
| [which-key](https://github.com/folke/which-key.nvim) | Key binding hints | 3aab214 |
| [yazi](https://github.com/mikavilpas/yazi.nvim) | File manager | ba8aa93 |

## Keymaps

| Key | Mode | Description |
|-----|------|-------------|
| `<C-w>` | n | Window Popup Menu |
| `<C-g>` | n | Git Popup Menu |
| `<C-l>` | n | Toggle list characters |
| `j` | n,x | Navigate visual line down |
| `k` | n,x | Navigate visual line up |
| `<Down>` | n,x | Navigate visual line down |
| `<Up>` | n,x | Navigate visual line up |
| `<Down>` | i | Navigate visual line down |
| `<Up>` | i | Navigate visual line up |
| `<leader>bb` | n | Switch to alternate buffer |
| `<leader>bn` | n | Next buffer |
| `<leader>bp` | n | Previous buffer |
| `<C-q>` | n | Visual block mode |
| `<A-k>` | n,i,v | Move line up |
| `<A-j>` | n,i,v | Move line down |
| `<leader>x` | n | Open file explorer |
| `<leader>q` | n | Quit Neovim |
| `<leader>w` | n | Save file |
| `<leader>s` | n | Source current file |
| `<leader>lx` | n | Execute current line (Lua) |
| `<leader>lx` | v | Execute selection (Lua) |
| `<C-c>` | x | Copy to system clipboard |
| `<C-x>` | x | Cut to system clipboard |
| `<C-v>` | n,i,x | Paste from system clipboard |
| `<C-a>` | n | Select all |
| `<C-z>` | n | Undo |
| `<C-y>` | n | Redo |
| `<C-s>` | n,i,v | Save file |
| `<leader>lg` | n | LazyGit |
| `<c-x>` | t | Quit LazyGit to Yazi |
| `<leader>-` | n,v | Open Yazi at current file |
| `<leader>cw` | n | Open Yazi in cwd |
| `<c-up>` | n | Resume last Yazi session |
| `<c-l>` | t | Open LazyGit from Yazi |
| `<leader>nf` | n | Generate function docstring |
| `<leader>nt` | n | Generate type/class docstring |
| `<leader>u` | n | Toggle UndoTree |
| `<leader>tf` | n | Telescope find files |
| `<leader>tg` | n | Telescope git files |
| `<leader>tb` | n | Telescope buffers |
| `<leader>th` | n | Telescope help tags |
| `<leader>tw` | n | Telescope find word |
| `<leader>a` | n | Add file to Harpoon list |
| `<C-e>` | n | Toggle Harpoon quick menu |
| `<C-1>` | n | Select Harpoon file 1 |
| `<C-2>` | n | Select Harpoon file 2 |
| `<C-3>` | n | Select Harpoon file 3 |
| `<leader>cc` | n | Color picker |
| `<leader>ct` | n | Toggle color highlighter |

## Folder Structure

```
lua/llawn/
├─ config/
│  ├─ autocmd.lua    → Autocommands
│  ├─ globals.lua    → Global variables
│  ├─ init.lua       → Initialization
│  ├─ keymaps.lua    → Key mappings
│  ├─ lsp.lua        → LSP configuration
│  ├─ menu.lua       → Menus
│  └─ options.lua    → Options
└─ plugins/
   ├─ lsp/
   │  ├─ cmp-nvim-lsp.lua → LSP completion integration
   │  └─ mason.lua        → Mason LSP manager
   ├─ ccc.lua        → Color picker
   ├─ colors.lua     → Theme configuration
   ├─ harpoon.lua    → File navigation
   ├─ lazygit.lua    → Git integration
   ├─ lualine.lua    → Status line
   ├─ neogen.lua     → Documentation generation
   ├─ nvim-cmp.lua   → Completion engine
   ├─ telescope.lua  → Fuzzy finder
   ├─ undotree.lua   → Undo tree
   ├─ which-key.lua  → Key binding hints
   └─ yazi.lua       → File manager
```

- `.config/nvim/after/lsp/` contains individual server configs for fine-tuning LSP behavior. For example, `flutter_ls.lua` customizes the Flutter Language Server by setting the command to use the Flutter SDK's analysis server, enabling Flutter-specific features like outline views and closing labels, and configuring completion and analysis options.
- `.config/nvim/lua/llawn/config/` centralizes configurations for LSP, keymaps, options, etc.
- `.config/nvim/lua/llawn/plugins/` holds all plugin setups.

## Installation

1. Clone this repository:

```bash
git clone git@github.com:llawn/llawnvim.git
```

2. Install plugins using Lazy:

```vim
:Lazy sync
```

3. Open Neovim and enjoy your fully configured setup.

## Documentation

Full documentation is available at [https://llawn.github.io/llawnvim/](https://llawn.github.io/llawnvim/)

---

This configuration draws inspiration from:

- [ThePrimeagen's init.lua](https://github.com/ThePrimeagen/init.lua)
- [Josean Martinez's dev-environment-files](https://github.com/josean-dev/dev-environment-files)
- [TJ DeVries' config.nvim](https://github.com/tjdevries/config.nvim)

This configuration is continuously updated and modular, making it easy to
expand with new languages or plugins.
