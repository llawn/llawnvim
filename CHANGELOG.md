# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-01-15

### Documentation

- update changelogs
- update changelogs

## [1.4.2] - 2026-01-14

### Documentation

- update documentation
- update changelogs
- update changelogs
- remove undeveloped llawn-ai plugin and update MkDocs color palette
- remove test note
- update changelogs

## [1.4.1] - 2026-01-14

### Added

- restore categorization of commits in changelog

### Documentation

- add test note for 1.4.1
- update changelogs

## [1.4.0] - 2026-01-14

### Documentation

- update changelogs

## [1.3.9] - 2026-01-14

### Documentation

- update changelogs

## [1.3.8] - 2026-01-14

### Documentation

- update changelogs

## [1.3.7] - 2026-01-14

### Fixed

- remove empty [Unreleased] section after tag push

### Documentation

- update changelogs

## [1.3.6] - 2026-01-14

### Added

- use 'Unreleased' section for pending commits without tags

### Fixed

- use echo -e to properly write newlines in changelogs
- use temp file in generate_entry to preserve trailing newlines
- correct next tag calculation in changelog script

### Documentation

- add changelog link to documentation index
- update changelogs

### Style

- add 2 blank lines between changelog sections

## [1.3.5] - 2026-01-14

### Added

- categorize commits in changelog by type (feat, fix, docs, etc.)

### Documentation

- update changelogs

## [1.3.4] - 2026-01-14

### Added

- update script to generate full changelogs from the beginning

## [1.3.3] - 2026-01-14

### Added

- update changelog script to generate docs/changelog.md automatically

## [1.3.2] - 2026-01-14

### Documentation

- add detailed changelog in docs/ and automation script

## [1.3.1] - 2026-01-14

### Documentation

- add changelog for version 1.3.0

## [1.3.0] - 2026-01-14

### Added

- update LSP, menu, and plugin configurations
- add menu system for various Neovim features

### Fixed

- fix treesitter when lang has no parsers available

### Refactored

- reorganize quit logic for better modularity

## [1.2.2] - 2026-01-13

### Added

- add "lockfiles" for Mason and Treesitter
- highlights colors handle # and 0x with virtual hint
- add a mason telescope menu

### Documentation

- update menu keymaps and folder structure
- update docs to account for mason menu, lockfiles and new color highlighter
- update some badges

## [1.2.1] - 2026-01-12

### Added

- add lexima for brackets
- custom config to ignore hover for ruff

## [1.2.0] - 2026-01-12

### Added

- add alpha to the plugins
- add treesitter with a better menu
- alpha on startup
- custom color picker plugin
- add color picker functionality for hex colors

### Fixed

- Update links in lsp.md
- Update links in README.md for lsp
- markdown links for ruff
- fix indentation in README.md

### Documentation

- links in README.md
- udapte docs, small improvements
- update documentation for treesitter and alpha and new local colors plugins

### Chore

- change name of my custom color picker plugin and remove ccc


- refactor(colors): reorganize color picker files to plugins/local directory and update documentation
- Add links for missing sections and convert Languages section to table format
- Update workflow to deploy MkDocs only on tag pushes
- Rename repository to llawnvim and update documentation links

## [1.1.0] - 2026-01-07

### Added

- clean log files on exit
- undo files in an undodir directory
- first documentation
- use mkdocs-material
- documentation automation with a makefile
- documentation with mkdocs

### Fixed

- keymaps overlaps with window menu

### Documentation

- fix admonitton support
- simplify documentation
- add a badge in readme for neovim

## [1.0.0] - 2026-01-06

### Added

- nvim-cmp support lsp configuration
- yazi open in full window and can open lazygit
- lualine support LSP
- lazygit now open in fullscreen and can open yazi directly
- plugins for hexcolor picker and highlighter
- update all my config files
- better readme description

### Fixed

- Update README.md
- try fixing again ascii character
- ascii rendering in markdown

### Documentation

- add custom keymaps desc
- add inspiration links
- update desc for after/lsp dir
- update init to not make info redundant with README
- forget Mason in readme plugins
- update readme with better plugins information and new repo structure
- docs for telescope
- doc for undotree
- add readme plugins links in README.md

### Style

- update readme table
- style for which-key
- fix style for neogen
- fix style for harpoon
- fixing style in header
- missing space before @brief
- Update lsp.lua with some section style


- enabling hints in lsp
- move lsp to after dir

## [0.1.0] - 2025-11-06

### Added

- add lsp
- add plugins
- nvim custom configuration

### Documentation

- add license and tags for readme
- add a readme


