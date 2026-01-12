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

My personal Neovim configuration, modular and optimized for multiple languages

This configuration draws inspiration from:

- [ThePrimeagen's init.lua](https://github.com/ThePrimeagen/init.lua)
- [Josean Martinez's dev-environment-files](https://github.com/josean-dev/dev-environment-files)
- [TJ DeVries' config.nvim](https://github.com/tjdevries/config.nvim)

## Local Plugins

- **Color Pickers**: Custom Telescope-based hex color picker (`:HexColors`) and 2D grid color picker (`:ColorPick2D`)

This configuration is continuously updated and modular, making it easy to
expand with new languages or plugins.

## Documentation

Full documentation is available at [https://llawn.github.io/llawnvim/](https://llawn.github.io/llawnvim/)

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

## Features

- **Lazy** plugin manager for fast startup.
- **Mason** for automatic LSP server installation.
- Built-in **LSP setup** using Neovim 0.11+ `vim.lsp.enable`.
- **Keymaps and menus** for window management, Git, Treesitter, and more.
- **Alpha dashboard** for a clean startup screen.
- Plugins configured:

| Plugin | Description | Version |
|--------|-------------|---------|
| [rose-pine](https://github.com/rose-pine/neovim) | Color scheme | cf2a288 |
| [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2) | File navigation | 87b1a35 |
| [lazygit](https://github.com/kdheepak/lazygit.nvim) | Git integration | a04ad0d |
| [lualine](https://github.com/nvim-lualine/lualine.nvim) | Status line | 47f91c4 |
| [neogen](https://github.com/danymat/neogen) | Documentation generation | 23e7e9f |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine | 85bbfad |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP completion integration | cbc7b02 |
| [mason](https://github.com/williamboman/mason.nvim) | LSP server manager | 44d1e90 |
| [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) | Mason LSP bridge | fe66109 |
| [telescope](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder | a8c2223 |
| [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting | 42fc28b |
| [undotree](https://github.com/mbbill/undotree) | Undo tree | 178d19e |
| [which-key](https://github.com/folke/which-key.nvim) | Key binding hints | 3aab214 |
| [yazi](https://github.com/mikavilpas/yazi.nvim) | File manager | 4a8bd32 |
| [alpha](https://github.com/goolord/alpha-nvim) | Dashboard | 3979b01 |

[More features](https://llawn.github.io/llawnvim/features/)

## Language Server Protocol

[LSP configurations](https://llawn.github.io/llawnvim/lsp/)

| Language | LSP Server |
|----------|------------|
| C/C++ | [clangd](https://clangd.llvm.org) |
| Flutter/Dart | flutter_ls |
| Fortran | [fortls](https://github.com/gnikit/fortls) |
| Go | [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) |
| Lua | [lua_ls](https://github.com/LuaLS/lua-language-server) |
| Python | [ty](https://github.com/astral-sh/ty/) + [ruff](https://github.com/astral-sh/ruff/) |


## Treesitter Parsers

The following parsers are automatically installed and configured:

| Language | Treesitter Parser |
|----------|-------------------|
| lua      | [lua](https://github.com/tree-sitter-grammars/tree-sitter-lua) |
| vim      | [vim](https://github.com/tree-sitter-grammars/tree-sitter-vim), [vimdoc](https://github.com/neovim/tree-sitter-vimdoc) |
| markdown | [markdown](https://github.com/tree-sitter-grammars/tree-sitter-markdown), [markdown_inline](https://github.com/tree-sitter-grammars/tree-sitter-markdown) |
| json     | [json](https://github.com/tree-sitter/tree-sitter-json) |
| tree-sitter query | [query](https://github.com/tree-sitter-grammars/tree-sitter-query) |

## Keymaps

[Full keymaps documentation](https://llawn.github.io/llawnvim/keymaps/)

## Folder Structure

[Full folder structure documentation](https://llawn.github.io/llawnvim/structure/)
