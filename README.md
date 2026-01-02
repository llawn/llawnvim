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
- Plugins configured:
  - [rose-pine](https://github.com/rose-pine/neovim)
  - [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)
  - [lazygit](https://github.com/kdheepak/lazygit.nvim)
  - [lualine](https://github.com/nvim-lualine/lualine.nvim)
  - [neogen](https://github.com/danymat/neogen)
  - [telescope](https://github.com/nvim-telescope/telescope.nvim)
  - [undotree](https://github.com/mbbill/undotree)
  - [which-key](https://github.com/folke/which-key.nvim)
  - [yazi](https://github.com/mikavilpas/yazi.nvim)

## Folder Structure

```
lua/llawn/
├─ config/    → LSP setups, keymaps, menus, autocmds, options
└─ plugins/   → Plugin configurations
```

- `.config/nvim/after/lsp/` contains individual server configs
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

---

This configuration is continuously updated and modular, making it easy to
expand with new languages or plugins.
