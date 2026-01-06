# LLawn Neovim Configuration

```markdown
    ██╗     ██╗      █████╗ ██╗    ██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
    ██║     ██║     ██╔══██╗██║    ██║████╗  ██║██║   ██║██║████╗ ████║
    ██║     ██║     ███████║██║ █╗ ██║██╔██╗ ██║██║   ██║██║██╔████╔██║
    ██║     ██║     ██╔══██║██║███╗██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ███████╗███████╗██║  ██║╚███╔███╔╝██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚══════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
```

[![GitHub License](https://img.shields.io/github/license/llawn/nvimconfig)](https://github.com/llawn/nvimconfig/blob/main/LICENSE)
[![GitHub repo size](https://img.shields.io/github/repo-size/llawn/nvimconfig)](https://github.com/llawn/nvimconfig)
[![GitHub Tag](https://img.shields.io/github/v/tag/llawn/nvimconfig)](https://github.com/llawn/nvimconfig/releases)
[![Neovim Version](https://img.shields.io/badge/Neovim-0.11+-57A143)](https://neovim.io/)
[![MkDocs](https://img.shields.io/badge/docs-mkdocs-blue)](https://llawn.github.io/nvimconfig/)

A modular, feature-rich Neovim configuration optimized for multiple programming languages including C/C++, Flutter/Dart, Fortran, Go, Lua, and Python.

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone git@github.com:llawn/nvimconfig.git ~/.config/nvim
   ```

2. **Install plugins:**
   ```vim
   :Lazy sync
   ```

3. **Start coding!** 🎉

## ✨ Key Features

- **Modern LSP Setup**: Built-in LSP configuration using Neovim 0.11+ features
- **Plugin Management**: Lazy-loaded plugins for optimal performance
- **Multi-Language Support**: Comprehensive language server configurations
- **Custom Keymaps**: Intuitive key bindings with popup menus
- **Beautiful UI**: Rose Pine theme with custom highlights
- **Productive Tools**: File navigation, git integration, fuzzy finding, and more

## 📚 Documentation

This documentation provides comprehensive guides for:

- [Features](features.md) - Detailed feature overview
- [Plugins](plugins.md) - Plugin configurations and usage
- [LSP Configurations](lsp.md) - Language server setup details
- [Keymaps](keymaps.md) - Complete key binding reference
- [Installation](installation.md) - Step-by-step setup guide
- [Folder Structure](structure.md) - Codebase organization

## 🎯 Supported Languages

| Language | LSP Server | Features |
|----------|------------|----------|
| C/C++ | clangd | Full language support, diagnostics |
| Flutter/Dart | flutter_ls | Hot reload, outline views, widgets |
| Fortran | fortls | Modern Fortran support |
| Go | gopls | Google's official Go language server |
| Lua | lua_ls | Lua language support with Neovim API |
| Python | ty + ruff | Type checking and linting |

## 🏗️ Architecture

This configuration follows a modular structure with separate concerns:

- **Core Configuration**: Editor options, keymaps, and LSP setup
- **Plugin Management**: Lazy-loaded plugins with dependency management
- **Language Support**: Dedicated LSP configurations per language
- **UI/UX**: Theme, status line, and interface customizations

## 🤝 Contributing

This configuration draws inspiration from the Neovim community:

- [ThePrimeagen's init.lua](https://github.com/ThePrimeagen/init.lua)
- [Josean Martinez's dev-environment-files](https://github.com/josean-dev-environment-files)
- [TJ DeVries' config.nvim](https://github.com/tjdevries/config.nvim)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/llawn/nvimconfig/blob/main/LICENSE) file for details.
