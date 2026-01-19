# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-01-20

### Added

- add changelog generation in makefile
- my custom color highlighter and picker plugin
- change some keymap to match group in which-key
- organize keymaps better with icon and desc
- add vim-be-good
- use dropdown menu for harpoon
- telescope with several plugins enhancement
- keymap for render-markdown
- Add color highlight for color cmp
- telescope menu for harpoon with deletion action
- add gitsigns plugin
- colors.lua
- change desc and open current work directory keymap
- factorize mason.lua menu and treesitter.lua menu
- use colors with lazy instead of locals
- add LSP configuration and lua_ls settings
- improve my colors plugin
- restore categorization of commits in changelog
- use 'Unreleased' section for pending commits without tags
- categorize commits in changelog by type (feat, fix, docs, etc.)
- update script to generate full changelogs from the beginning
- update changelog script to generate docs/changelog.md automatically
- update LSP, menu, and plugin configurations
- add menu system for various Neovim features
- add "lockfiles" for Mason and Treesitter
- highlights colors handle # and 0x with virtual hint
- add a mason telescope menu
- add lexima for brackets
- custom config to ignore hover for ruff
- add alpha to the plugins
- add treesitter with a better menu
- alpha on startup
- custom color picker plugin
- add color picker functionality for hex colors
- clean log files on exit
- undo files in an undodir directory
- first documentation
- use mkdocs-material
- documentation automation with a makefile
- documentation with mkdocs
- nvim-cmp support lsp configuration
- yazi open in full window and can open lazygit
- lualine support LSP
- lazygit now open in fullscreen and can open yazi directly
- plugins for hexcolor picker and highlighter
- update all my config files
- better readme description
- add lsp
- add plugins
- nvim custom configuration

### Fixed

- correct nil handle
- change lsp keymap to <leader>p
- Icon color for LSP and TS
- harpoon emit the remove to the harpoon save file
- simplify the call to treesitter
- reorder keymaps and change some mappings
- remove menu.lua
- undodir to default .local/state and remove mode indicator
- lazy.lua
- grid_color_picker
- fix generate changelog script
- remove empty [Unreleased] section after tag push
- use echo -e to properly write newlines in changelogs
- use temp file in generate_entry to preserve trailing newlines
- correct next tag calculation in changelog script
- fix treesitter when lang has no parsers available
- Update links in lsp.md
- Update links in README.md for lsp
- markdown links for ruff
- fix indentation in README.md
- keymaps overlaps with window menu
- Update README.md
- try fixing again ascii character
- ascii rendering in markdown

### Documentation

- update changelogs
- update changelogs
- update documentation
- update changelogs
- update changelogs
- remove undeveloped llawn-ai plugin and update MkDocs color palette
- remove test note
- update changelogs
- add test note for 1.4.1
- update changelogs
- update changelogs
- update changelogs
- update changelogs
- update changelogs
- add changelog link to documentation index
- update changelogs
- update changelogs
- add detailed changelog in docs/ and automation script
- add changelog for version 1.3.0
- update menu keymaps and folder structure
- update docs to account for mason menu, lockfiles and new color highlighter
- update some badges
- links in README.md
- udapte docs, small improvements
- update documentation for treesitter and alpha and new local colors plugins
- fix admonitton support
- simplify documentation
- add a badge in readme for neovim
- add custom keymaps desc
- add inspiration links
- update desc for after/lsp dir
- update init to not make info redundant with README
- forget Mason in readme plugins
- update readme with better plugins information and new repo structure
- docs for telescope
- doc for undotree
- add readme plugins links in README.md
- add license and tags for readme
- add a readme

### Style

- format file
- format file
- better header
- git menu
- mason header
- style for lsp cmp plugin
- format git file and fix sorter
- better header for yazi plugin
- better header for undotree
- update TS file header
- neogen
- improve lexima header
- lazygit
- alpha.lua
- correct diff.lua and lockfile.lua style
- format window.lua
- change header in globals
- change header style
- add 2 blank lines between changelog sections
- update readme table
- style for which-key
- fix style for neogen
- fix style for harpoon
- fixing style in header
- missing space before @brief
- Update lsp.lua with some section style

### Refactored

- refactorization of entry maker for treesitter.lua and mason.lua
- diff preview for unsaved and formatting
- refactor some functions in autocmd
- reorganize quit logic for better modularity

### Chore

- move changelog to a scripts directory
- my lazy lockfile update
- change name of menu functions to ts_symbols
- change name of my custom color picker plugin and remove ccc


- refactor(colors): reorganize color picker files to plugins/local directory and update documentation
- Add links for missing sections and convert Languages section to table format
- Update workflow to deploy MkDocs only on tag pushes
- Rename repository to llawnvim and update documentation links
- enabling hints in lsp
- move lsp to after dir


