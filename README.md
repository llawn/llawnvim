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
git clone git@github.com:llawn/nvimconfig.git
```

2. Install plugins using Lazy:

```vim
:Lazy sync
```

3. Open Neovim and enjoy your fully configured setup.

---

This configuration is continuously updated and modular, making it easy to
expand with new languages or plugins.
