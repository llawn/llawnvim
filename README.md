```markdown

      ██╗     ██╗      █████╗ ██╗    ██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
      ██║     ██║     ██╔══██╗██║    ██║████╗  ██║██║   ██║██║████╗ ████║
      ██║     ██║     ███████║██║ █╗ ██║██╔██╗ ██║██║   ██║██║██╔████╔██║
      ██║     ██║     ██╔══██║██║███╗██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
      ███████╗███████╗██║  ██║╚███╔███╔╝██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚══════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
```

______________________________________________________________________

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

This configuration is continuously updated and modular, making it easy to expand
with new languages or plugins.

![Banner](./assets/header.png)

## Documentation

Full documentation is available at
[https://llawn.github.io/llawnvim/](https://llawn.github.io/llawnvim/)

## Installation

1. Clone this repository:

```bash
git clone git@github.com:llawn/llawnvim.git
```

1. Install plugins using Lazy:

```vim
:Lazy sync
```

1. Open Neovim and enjoy your fully configured setup.

The configuration uses lock files (`lazy-lock.json`, `mason-lock.json`,
`treesitter-lock.json`) to ensure reproducible installations across
environments.

## Features

|Plugin|Description|Version|
|---|---|---|
| [alpha](https://github.com/goolord/alpha-nvim)|Dashboard|3979b01|
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)|LSP completion integration|cbc7b02|
| [conform](https://github.com/stevearc/conform.nvim)|Code formatter|c2526f1|
| [gitsigns](https://github.com/lewis6991/gitsigns.nvim)|Git signs and hunk management|42d6aed|
| [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)|File navigation|87b1a35|
| [lazygit](https://github.com/kdheepak/lazygit.nvim)| Git integration|a04ad0d|
| [lexima](https://github.com/cohama/lexima.vim)| Auto close parentheses|ab621e4|
| [lazy.nvim](https://github.com/folke/lazy.nvim)|Nvim Plugin Manager|306a055|
| [llawn.colors](https://github.com/llawn/llawn.colors)| Custom color utilities|87a46d9|
| [lualine](https://github.com/nvim-lualine/lualine.nvim)| Status line|47f91c4|
| [mason](https://github.com/williamboman/mason.nvim)| LSP server manager|44d1e90|
| [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim)|Mason LSP bridge|fe66109|
| [neogen](https://github.com/danymat/neogen)|Documentation generation|23e7e9f|
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)|Completion engine|85bbfad|
| [nvim-lint](https://github.com/mfussenegger/nvim-lint)|Linter|ca6ea12|
| [render-markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim)|Markdown rendering|c54380d|
| [rose-pine](https://github.com/rose-pine/neovim)|Color scheme|cf2a288|
| [telescope](https://github.com/nvim-telescope/telescope.nvim)|Fuzzy finder|a8c2223|
| [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)|Syntax highlighting|42fc28b|
| [undotree](https://github.com/mbbill/undotree)|Undo tree|178d19e|
| [vim-be-good](https://github.com/ThePrimeagen/vim-be-good)|Vim practice game|0ae3de1|
| [which-key](https://github.com/folke/which-key.nvim)|Key binding hints|3aab214|
| [yazi](https://github.com/mikavilpas/yazi.nvim)|File manager|4a8bd32|

- Built-in **LSP setup** using Neovim 0.11+ `vim.lsp.enable`.
- Custom menus for Git, Treesitter, Mason and more.

[More features](https://llawn.github.io/llawnvim/features/)

## Additional Dependencies

The following plugins are installed as dependencies:

|Plugin|Description|Version|
|---|---|---|
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)|Buffer completion source|b74fab3|
| [cmp-path](https://github.com/hrsh7th/cmp-path)|Path completion source|c642487|
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)|LuaSnip completion source|98d9cb5|
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)|Snippet collection|572f566|
| [lazydev.nvim](https://github.com/folke/lazydev.nvim)|Lazy development tools|5231c62|
| [lspkind.nvim](https://github.com/onsails/lspkind.nvim)|LSP pictograms|53374a2|
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip)|Snippet engine|5a1e392|
| [nvim-lsp-file-operations](https://github.com/antosha417/nvim-lsp-file-operations)|LSP file operations|b9c795d|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)|LSP configurations|92ee7d4|
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)|Treesitter text objects|5ca4aaa|
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)|File icons|8033534|
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)|Utility functions|b9fd522|
| [sqlite.lua](https://github.com/kkharji/sqlite.lua)|SQLite Lua binding|50092d6|
| [telescope-frecency.nvim](https://github.com/nvim-telescope/telescope-frecency.nvim)|Frecency algorithm|fc6418b|
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)|FZF sorter|6fea601|
| [telescope-github.nvim](https://github.com/nvim-telescope/telescope-github.nvim)|GitHub integration|ec150c5|
| [telescope-live-grep-args.nvim](https://github.com/nvim-telescope/telescope-live-grep-args.nvim)|Live grep with args|b80ec2c|
| [telescope-project.nvim](https://github.com/nvim-telescope/telescope-project.nvim)|Project management|8e11df9|
| [telescope-symbols.nvim](https://github.com/nvim-telescope/telescope-symbols.nvim)|Symbols picker|a6d0127|
| [telescope-undo.nvim](https://github.com/nvim-telescope/telescope-undo.nvim)|Undo history|928d0c2|

## Language Server Protocol

[LSP configurations](https://llawn.github.io/llawnvim/lsp/)

Integrated with [conform](https://github.com/stevearc/conform.nvim) for
formatting and [nvim-lint](https://github.com/mfussenegger/nvim-lint) for
linting, both auto-detecting tools from Mason.

| Language|LSP Server|
|---|---|
| C/C++|[clangd](https://clangd.llvm.org)|
| Flutter/Dart|flutter_ls|
| Fortran|[fortls](https://fortls.fortran-lang.org)|
| Go|[gopls](https://go.dev/gopls/)|
| Lua|[lua_ls](https://luals.github.io/)|
| Python|[ty](https://docs.astral.sh/ty/) + [ruff](https://docs.astral.sh/ruff/)|

## Treesitter Parsers

The following parsers are automatically installed and configured:

| Language|Treesitter Parser|
|---|---|
| lua|[lua](https://github.com/tree-sitter-grammars/tree-sitter-lua)|
| vim|[vim](https://github.com/tree-sitter-grammars/tree-sitter-vim), [vimdoc](https://github.com/neovim/tree-sitter-vimdoc)|
| markdown|[markdown, markdown_inline](https://github.com/tree-sitter-grammars/tree-sitter-markdown)|
| json|[json](https://github.com/tree-sitter/tree-sitter-json)|
| tree-sitter query|[query](https://github.com/tree-sitter-grammars/tree-sitter-query)|

## Keymaps

[Full keymaps documentation](https://llawn.github.io/llawnvim/keymaps/)

## Folder Structure

[Full folder structure documentation](https://llawn.github.io/llawnvim/structure/)
