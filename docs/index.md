---
title: LLawn Neovim Configuration
description: A modular, feature-rich Neovim configuration optimized for multiple programming languages
icon: material/home
---

# LLawn Neovim Configuration

```markdown
    ██╗     ██╗      █████╗ ██╗    ██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
    ██║     ██║     ██╔══██╗██║    ██║████╗  ██║██║   ██║██║████╗ ████║
    ██║     ██║     ███████║██║ █╗ ██║██╔██╗ ██║██║   ██║██║██╔████╔██║
    ██║     ██║     ██╔══██║██║███╗██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ███████╗███████╗██║  ██║╚███╔███╔╝██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚══════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
```

![GitHub License](https://img.shields.io/github/license/llawn/llawnvim)
![GitHub repo size](https://img.shields.io/github/repo-size/llawn/llawnvim)
![GitHub Tag](https://img.shields.io/github/v/tag/llawn/llawnvim)
![Neovim Version](https://img.shields.io/badge/Neovim-0.11+-57A143)
[![MkDocs](https://img.shields.io/badge/docs-mkdocs-blue)](https://llawn.github.io/llawnvim/)

A modular, feature-rich Neovim configuration optimized for multiple programming
languages including C/C++, Flutter/Dart, Fortran, Go, Lua, and Python.

## Quick Start

1. **Clone the repository:**

    ```bash
    git clone git@github.com:llawn/llawnvim.git ~/.config/nvim
    ```

2. **Install plugins:**

    ```vim
    :Lazy sync
    ```

3. **Start coding!**

## Key Features

- **Modern LSP Setup**: Built-in LSP configuration using Neovim 0.11+ features
- **Plugin Management**: Lazy-loaded plugins for optimal performance
- **Multi-Language Support**: Comprehensive language server configurations
- **Custom Keymaps**: Intuitive key bindings with popup menus
- **Beautiful UI**: Rose Pine theme with custom highlights
- **Productive Tools**: File navigation, git integration, fuzzy finding, and
  more

## Documentation

This documentation provides comprehensive guides for:

- [Features](features.md) - Detailed feature overview and plugin ecosystem
- [LSP Configurations](lsp.md) - Language server setup details
- [Keymaps](keymaps.md) - Complete key binding reference
- [Installation](installation.md) - Step-by-step setup guide
- [Folder Structure](structure.md) - Codebase organization
- [Changelog](changelog/index.md) - Version history and changes

## Architecture

This configuration follows a modular structure with separate concerns:

- **Configuration Configuration**: Editor options, keymaps, LSP setup, UI
  preferences
- **Plugin Management**: Lazy-loaded plugins with dependency management
- **Language Support**: Dedicated LSP configurations per language

## Contributing

This configuration draws inspiration from the Neovim community:

- [ThePrimeagen's init.lua](https://github.com/ThePrimeagen/init.lua)
- [Josean Martinez's dev-environment-files](https://github.com/josean-dev-environment-files)
- [TJ DeVries' config.nvim](https://github.com/tjdevries/config.nvim)

## License

This project is licensed under the MIT License - see the
[LICENSE](https://github.com/llawn/llawnvim/blob/main/LICENSE) file for details.
