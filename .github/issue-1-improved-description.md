## Summary
Migrate the plugin management system from Lazy.nvim to Neovim's native package manager (`vim.pack`) to prepare for Neovim 0.12 and simplify the configuration.

## Current State
- Plugin management handled by Lazy.nvim
- Custom plugin specifications in `lua/llawn/plugins/`
- Lazy loader configurations and dependency management
- Approximately 20+ plugins configured

## Motivation
Neovim 0.12 introduces a native package manager (`vim.pack`) that provides:
- Built-in plugin management without external dependencies
- Better integration with Neovim's core functionality
- Simplified startup and reduced complexity
- Future-proof compatibility with Neovim's direction

## Implementation Plan

### Phase 1: Research and Planning
- [ ] Investigate `vim.pack` API and capabilities
- [ ] Document current Lazy configuration
- [ ] Identify potential compatibility issues

### Phase 2: Directory Structure Setup
- [ ] Create `pack/llawn/start/` for essential plugins
- [ ] Create `pack/llawn/opt/` for optional plugins
- [ ] Set up git submodules or direct cloning structure

### Phase 3: Plugin Migration
- [ ] Convert Lazy plugin specs to `vim.pack` format
- [ ] Update plugin loading logic (`vim.cmd.packadd()`)
- [ ] Migrate plugin configurations
- [ ] Handle plugin dependencies and load order

### Phase 4: Testing and Validation
- [ ] Test plugin loading and functionality
- [ ] Validate startup performance
- [ ] Cross-platform testing (Linux, macOS, Windows)
- [ ] Documentation updates

### Phase 5: Deprecation and Removal
- [ ] Update README and installation instructions
- [ ] Provide migration guide for users
- [ ] Remove Lazy dependencies

## Breaking Changes
- Users will need to manage plugins differently (submodules vs Lazy)
- Some Lazy-specific features may be lost
- Plugin update mechanism changes
- Potential impact on startup time

## Benefits
- Reduced external dependencies
- Better Neovim integration
- Simplified maintenance
- Future compatibility with Neovim 0.12+

## Acceptance Criteria
- [ ] All current plugins load correctly with `vim.pack`
- [ ] No regression in functionality
- [ ] Startup time maintained or improved
- [ ] Documentation updated
- [ ] Migration guide provided
- [ ] CI/CD tests pass on all platforms

## Related Files
- `lua/llawn/plugins/` - Current plugin configurations
- `lua/llawn/config/lazy.lua` - Lazy configuration
- `README.md` - Installation instructions
- `docs/installation.md` - Setup documentation

## References
- [Neovim 0.12 Release Notes](https://github.com/neovim/neovim/releases) (when available)
- [vim.pack documentation](https://neovim.io/doc/user/usr_05.html#packages)