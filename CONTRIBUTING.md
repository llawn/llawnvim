# Contributing

Thank you for your interest in contributing to LLawn Neovim Configuration! This
document provides guidelines for contributing to the project.

## Ways to Contribute

- **Bug Reports**: Report bugs via
  [GitHub Issues](https://github.com/llawn/llawnvim/issues)
- **Feature Requests**: Suggest new features via
  [GitHub Issues](https://github.com/llawn/llawnvim/issues)
- **Code Contributions**: Submit pull requests with improvements
- **Documentation**: Help improve documentation and guides

## Development Setup

1. Clone the repository: `git clone https://github.com/llawn/llawnvim.git`
2. Set up the configuration following the
   [Installation Guide](docs/installation.md)
3. Create a feature branch: `git checkout -b feature/your-feature`

## Code Style

### Lua Code

- Follow the existing code style in the repository
- Use consistent indentation (2 spaces)
- Add comments for complex logic
- Use meaningful variable and function names

### Keymaps

- Document keymaps in `lua/llawn/plugin/which-key.lua`
- Update `docs/keymaps.md` when adding new mappings
- Use descriptive key descriptions

## Testing

- Run `:checkhealth` to ensure no issues
- Verify LSP servers work correctly
- Test plugin functionality

## Pull Request Process

1. Ensure your code follows the style guidelines
2. Update documentation if needed
3. Test thoroughly
4. Submit a pull request with a clear description
5. Address any review comments

## Documentation Contribution

Documentation is crucial for this project. Here's how to contribute:

### Types of Documentation

- **User Guides**: Installation, configuration, usage guides in `docs/`
- **API Documentation**: Code comments and docstrings
- **Changelogs**: Automatically generated, but can be improved

### Documentation Guidelines

- Use clear, concise language
- Include code examples where helpful
- Keep documentation up-to-date with code changes
- Use MkDocs Material formatting for docs in `docs/`

### Updating Documentation

- Edit files in the `docs/` directory
- Use MkDocs Material syntax (admonitions, code blocks, etc.)
- Test documentation locally: `make serve`
- Ensure links and references are correct

### Changelog Management

- Changelogs are automatically generated via git hooks
- Manual improvements to changelog formatting are welcome
- Follow [Keep a Changelog](https://keepachangelog.com/) format

## Commit Messages

Use clear, descriptive commit messages:

```
feat: add new LSP configuration for Rust
fix: resolve keymap conflict in telescope
docs: update installation guide for new prerequisites
```

## License

By contributing, you agree that your contributions will be licensed under the
same MIT License as the project.

## Getting Help

- Check existing [Issues](https://github.com/llawn/llawnvim/issues) and
  [Discussions](https://github.com/llawn/llawnvim/discussions)
- Ask questions in GitHub Discussions
- Review the [Documentation](llawn.github.io/llawnvim/) in /docs

Thank you for contributing to LLawn Neovim Configuration!
