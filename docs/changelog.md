# Changelog

## [Unreleased] - 2026-01-14\n\n### Details of Changes\n\n```\n    commit 30cd1b6 fix: use temp file in generate_entry to preserve trailing newlines
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 18:19:15 2026 +0100
    
    
     CHANGELOG.md          | 45 ++++++++++++++++++++++++++++++++++++---------
     docs/changelog.md     | 12 +++++++++++-
     generate_changelog.sh | 17 ++++++++++++-----
     3 files changed, 59 insertions(+), 15 deletions(-)
    
    commit 70b76ed fix: correct next tag calculation in changelog script
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 18:17:03 2026 +0100
    
    
     CHANGELOG.md          |  68 ++++-
     docs/changelog.md     | 778 +++++++++++++++++++++++++++++++++++++++++++++++++-
     generate_changelog.sh |  98 ++-----
     3 files changed, 863 insertions(+), 81 deletions(-)
    
    commit 563f990 docs: update changelogs
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 18:13:33 2026 +0100
    
    
     CHANGELOG.md      |  67 +----
     docs/changelog.md | 756 +-----------------------------------------------------
     2 files changed, 2 insertions(+), 821 deletions(-)\n```\n\n## [1.3.5] - 2026-01-14\n\n### Details of Changes\n\n```\n    commit caac1da feat: categorize commits in changelog by type (feat, fix, docs, etc.)
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 18:13:22 2026 +0100
    
    
     generate_changelog.sh | 78 +++++++++++++++++++++++++++++++++++++++++++++------
     1 file changed, 70 insertions(+), 8 deletions(-)
    
    commit 944fdaf docs: update changelogs
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 18:11:17 2026 +0100
    
    
     CHANGELOG.md      |  81 +++++-
     docs/changelog.md | 809 ++++++++++++++++++++++++++++++++++++++++++++++++++----
     2 files changed, 821 insertions(+), 69 deletions(-)\n```\n\n## [1.3.4] - 2026-01-14\n\n### Details of Changes\n\n```\n    commit bbbd4cf feat: update script to generate full changelogs from the beginning
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 18:11:06 2026 +0100
    
    
     generate_changelog.sh | 80 +++++++++++++++++++++++++++++++++++++--------------
     1 file changed, 58 insertions(+), 22 deletions(-)\n```\n\n## [1.3.3] - 2026-01-14\n\n### Details of Changes\n\n```\n    commit 5de755c feat: update changelog script to generate docs/changelog.md automatically
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 18:05:12 2026 +0100
    
    
     generate_changelog.sh | 6 ++++++
     1 file changed, 6 insertions(+)\n```\n\n## [1.3.2] - 2026-01-14\n\n### Details of Changes\n\n```\n    commit ed70b50 docs: add detailed changelog in docs/ and automation script
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 18:00:10 2026 +0100
    
    
     docs/changelog.md     | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++
     generate_changelog.sh | 22 ++++++++++++++++++++
     2 files changed, 78 insertions(+)\n```\n\n## [1.3.1] - 2026-01-14\n\n### Details of Changes\n\n```\n    commit 9236993 docs: add changelog for version 1.3.0
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 17:57:37 2026 +0100
    
    
     CHANGELOG.md | 22 ++++++++++++++++++++++
     1 file changed, 22 insertions(+)\n```\n\n## [1.3.0] - 2026-01-14\n\n### Details of Changes\n\n```\n    commit 1de7368 feat: update LSP, menu, and plugin configurations
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 17:19:52 2026 +0100
    
    - Update init.lua for menu integration and loading
    - Modify lsp.lua for improved configurations
    - Update menu.lua for enhanced menu access
    - Update telescope.lua plugin configuration
    - Update mason-lock.json and treesitter-lock.json for plugin locks
    
     init.lua                        |   3 +-
     lua/llawn/config/lsp.lua        |  21 ++
     lua/llawn/config/menu.lua       | 601 ++--------------------------------------
     lua/llawn/plugins/telescope.lua |   6 +
     mason-lock.json                 |   1 +
     treesitter-lock.json            |   1 +
     6 files changed, 48 insertions(+), 585 deletions(-)
    
    commit 95141bf refactor: reorganize quit logic for better modularity
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 17:19:39 2026 +0100
    
    - Move smart quit function to quit.lua as M.quit.smart_quit
    - Update <leader>q to call the centralized smart quit function
    - Smart quit opens quit menu when unsaved buffers detected
    - Add 'Unsaved Menu' as first option in quit menu for user choice
    
     lua/llawn/config/keymaps.lua | 16 +++++++++-------
     1 file changed, 9 insertions(+), 7 deletions(-)
    
    commit 9e39512 feat: add menu system for various Neovim features
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 17:19:28 2026 +0100
    
    - Add menu.lua for centralized menu access
    - Add init.lua integration for menu loading
    - Add mason.lua for Mason package manager menu
    - Add treesitter.lua for Treesitter parser menu
    - Add window.lua for window management menu
    - Add unsaved.lua for handling unsaved buffers
    - Add swapfiles.lua for swap file management
    - Add quit.lua for quit options with smart quit logic
    - Add git.lua for advanced git log with async loading, tags, browser integration, and floating viewer
    - Support conventional commit types with scoped highlighting
    - <C-o> to open commit in browser (GitHub, GitLab, Codeberg)
    - <CR> for floating commit view with <Esc> to return preserving search
    
     lua/llawn/config/menu/git.lua        | 451 +++++++++++++++++++++++++++++++++++
     lua/llawn/config/menu/init.lua       |  22 ++
     lua/llawn/config/menu/mason.lua      | 232 ++++++++++++++++++
     lua/llawn/config/menu/quit.lua       |  48 ++++
     lua/llawn/config/menu/swapfiles.lua  | 218 +++++++++++++++++
     lua/llawn/config/menu/treesitter.lua | 312 ++++++++++++++++++++++++
     lua/llawn/config/menu/unsaved.lua    | 130 ++++++++++
     lua/llawn/config/menu/window.lua     |  28 +++
     8 files changed, 1441 insertions(+)
    
    commit e9e3cc4 fix: fix treesitter when lang has no parsers available
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 14 05:27:16 2026 +0100
    
    
     lua/llawn/plugins/treesitter.lua | 2 +-
     1 file changed, 1 insertion(+), 1 deletion(-)\n```\n\n## [1.2.2] - 2026-01-13\n\n### Details of Changes\n\n```\n    commit 01654d7 docs: update menu keymaps and folder structure
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 13 22:45:51 2026 +0100
    
    
     docs/keymaps.md                      |  8 ++++++++
     docs/structure.md                    | 12 ++++++++++++
     lua/llawn/plugins/llawn-ai.lua       | 17 +++++++++++++++++
     lua/llawn/plugins/local/palettes.lua |  7 +++++++
     4 files changed, 44 insertions(+)
    
    commit 700e6fe docs: update docs to account for mason menu, lockfiles and new color highlighter
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 13 22:42:14 2026 +0100
    
    
     docs/features.md |  5 ++++-
     docs/keymaps.md  | 13 +++++++++++++
     2 files changed, 17 insertions(+), 1 deletion(-)
    
    commit b63e9fc docs: update some badges
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 13 22:39:05 2026 +0100
    
    
     docs/index.md | 8 ++++----
     1 file changed, 4 insertions(+), 4 deletions(-)
    
    commit dea8796 feat: add "lockfiles" for Mason and Treesitter
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 13 22:38:34 2026 +0100
    
    
     lua/llawn/plugins/lsp/mason.lua  | 38 ++++++++++++++++++++++++++++
     lua/llawn/plugins/treesitter.lua | 53 +++++++++++++++++++++++++++++++++++++++-
     mason-lock.json                  | 10 ++++++++
     treesitter-lock.json             | 14 +++++++++++
     4 files changed, 114 insertions(+), 1 deletion(-)
    
    commit a7c4995 feat: highlights colors handle # and 0x with virtual hint
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 13 22:30:25 2026 +0100
    
    
     lua/llawn/plugins/colors.lua                   |  20 +++--
     lua/llawn/plugins/local/colors_highlighter.lua | 117 +++++++++++++++++++++++++
     lua/llawn/plugins/local/colors_utils.lua       |  12 ++-
     3 files changed, 139 insertions(+), 10 deletions(-)
    
    commit 85735cb feat: add a mason telescope menu
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 13 22:15:11 2026 +0100
    
    
     lua/llawn/config/keymaps.lua |   3 +
     lua/llawn/config/menu.lua    | 238 ++++++++++++++++++++++++++++++++++++++++++-
     2 files changed, 240 insertions(+), 1 deletion(-)\n```\n\n## [1.2.1] - 2026-01-12\n\n### Details of Changes\n\n```\n    commit cccdbb0 feat: add lexima for brackets
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 19:44:50 2026 +0100
    
    
     README.md                    | 1 +
     docs/features.md             | 7 +++++++
     lua/llawn/plugins/lexima.lua | 8 ++++++++
     3 files changed, 16 insertions(+)
    
    commit ebef711 feat: custom config to ignore hover for ruff
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 19:44:22 2026 +0100
    
    
     after/lsp/ruff.lua | 18 ++++++++++++++++++
     lazy-lock.json     |  1 +
     2 files changed, 19 insertions(+)\n```\n\n## [1.2.0] - 2026-01-12\n\n### Details of Changes\n\n```\n    commit 4bedcff fix: Update links in lsp.md
    Author: llawn <151925221+llawn@users.noreply.github.com>
    Date: Mon Jan 12 18:01:08 2026 +0100
    
    
     docs/lsp.md | 8 ++++----
     1 file changed, 4 insertions(+), 4 deletions(-)
    
    commit 6cd1a68 fix: Update links in README.md for lsp
    Author: llawn <151925221+llawn@users.noreply.github.com>
    Date: Mon Jan 12 18:00:09 2026 +0100
    
    
     README.md | 8 ++++----
     1 file changed, 4 insertions(+), 4 deletions(-)
    
    commit 0dd9771 fix: markdown links for ruff
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 17:53:24 2026 +0100
    
    
     README.md   | 2 +-
     docs/lsp.md | 2 +-
     2 files changed, 2 insertions(+), 2 deletions(-)
    
    commit b10a97c docs: links in README.md
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 17:51:59 2026 +0100
    
    
     README.md | 31 +++++++++++++++----------------
     1 file changed, 15 insertions(+), 16 deletions(-)
    
    commit 0dcfb0a docs: udapte docs, small improvements
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 17:44:04 2026 +0100
    
    
     docs/features.md  | 76 ++++++++++++++-----------------------------------------
     docs/index.md     |  2 +-
     docs/keymaps.md   |  6 +++--
     docs/lsp.md       | 34 +++++++++++--------------
     docs/structure.md | 36 ++++++++++++++++++++++++++
     5 files changed, 75 insertions(+), 79 deletions(-)
    
    commit 86c23bb docs: update documentation for treesitter and alpha and new local colors plugins
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 16:51:54 2026 +0100
    
    
     README.md         | 34 +++++++++++++++-----
     docs/features.md  | 49 +++++++++++++++++++++++++----
     docs/keymaps.md   | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
     docs/structure.md | 21 +++++++------
     lazy-lock.json    | 17 +++++-----
     5 files changed, 179 insertions(+), 36 deletions(-)
    
    commit 5e17ee9 feat: add alpha to the plugins
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 16:42:32 2026 +0100
    
    
     lua/llawn/plugins/alpha.lua | 2 +-
     1 file changed, 1 insertion(+), 1 deletion(-)
    
    commit c9337c6 chore: change name of my custom color picker plugin and remove ccc
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 16:42:03 2026 +0100
    
    
     lua/llawn/config/init.lua                            |  4 ++--
     lua/llawn/plugins/ccc.lua                            | 20 --------------------
     .../{color_picking_2d.lua => grid_color_picker.lua}  |  0
     .../{hex_colors.lua => telescope_color_picker.lua}   |  0
     lua/llawn/plugins/nvim-cmp.lua                       |  2 +-
     5 files changed, 3 insertions(+), 23 deletions(-)
    
    commit 484e958 feat: add treesitter with a better menu
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 16:40:20 2026 +0100
    
    
     lua/llawn/config/keymaps.lua     |  19 +++
     lua/llawn/config/menu.lua        | 310 ++++++++++++++++++++++++++++++++++++++-
     lua/llawn/plugins/lualine.lua    |  15 +-
     lua/llawn/plugins/treesitter.lua | 131 +++++++++++++++++
     4 files changed, 467 insertions(+), 8 deletions(-)
    
    commit 3e01741 feat: alpha on startup
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 12 15:46:06 2026 +0100
    
    
     lua/llawn/config/autocmd.lua | 14 ++++++++++++++
     lua/llawn/plugins/alpha.lua  | 28 ++++++++++++++++++++++++++++
     2 files changed, 42 insertions(+)
    
    commit 2bf9393 feat: custom color picker plugin
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 23:49:47 2026 +0100
    
    - Integration with telescope
    - Completions
    
     lua/llawn/config/init.lua                    |    1 +
     lua/llawn/config/keymaps.lua                 |    4 +-
     lua/llawn/plugins/ccc.lua                    |    1 -
     lua/llawn/plugins/colors.lua                 |    8 +-
     lua/llawn/plugins/local/color_picking_2d.lua |  193 +++++
     lua/llawn/plugins/local/colors.lua           | 1082 +++++++++++++-------------
     lua/llawn/plugins/local/colors_utils.lua     |  125 +++
     lua/llawn/plugins/local/hex_colors.lua       |  228 +++---
     8 files changed, 986 insertions(+), 656 deletions(-)
    
    commit e2aa8a6 refactor(colors): reorganize color picker files to plugins/local directory and update documentation
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 18:47:13 2026 +0100
    
    
     docs/features.md                                   |  4 ++--
     docs/keymaps.md                                    |  3 ++-
     docs/structure.md                                  | 23 ++++++++++++++++++++++
     lua/llawn/config/init.lua                          |  2 +-
     lua/llawn/config/keymaps.lua                       |  2 +-
     lua/llawn/{config => plugins/local}/colors.lua     |  0
     lua/llawn/{config => plugins/local}/hex_colors.lua |  2 +-
     lua/llawn/plugins/nvim-cmp.lua                     |  2 +-
     8 files changed, 31 insertions(+), 7 deletions(-)
    
    commit 88af3e1 feat: add color picker functionality for hex colors
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 16:15:20 2026 +0100
    
    
     init.lua                        |   1 -
     lua/llawn/config/colors.lua     | 544 ++++++++++++++++++++++++++++++++++++++++
     lua/llawn/config/hex_colors.lua | 254 +++++++++++++++++++
     lua/llawn/config/init.lua       |   1 +
     lua/llawn/config/keymaps.lua    |   7 +
     lua/llawn/plugins/nvim-cmp.lua  |  49 ++--
     6 files changed, 841 insertions(+), 15 deletions(-)
    
    commit e151c72 fix: fix indentation in README.md
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 10:23:39 2026 +0100
    
    
     README.md | 20 ++++++++++----------
     1 file changed, 10 insertions(+), 10 deletions(-)
    
    commit 56b0c6a Add links for missing sections and convert Languages section to table format
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 10:21:43 2026 +0100
    
    
     README.md | 161 +++++++++++++++++---------------------------------------------
     1 file changed, 44 insertions(+), 117 deletions(-)
    
    commit 629c017 Update workflow to deploy MkDocs only on tag pushes
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 10:12:01 2026 +0100
    
    
     .github/workflows/deploy.yml | 3 ++-
     1 file changed, 2 insertions(+), 1 deletion(-)
    
    commit 7d3b3a0 Rename repository to llawnvim and update documentation links
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 10:06:48 2026 +0100
    
    
     README.md            | 12 ++++++------
     docs/index.md        | 12 ++++++------
     docs/installation.md |  4 ++--
     mkdocs.yml           |  2 +-
     4 files changed, 15 insertions(+), 15 deletions(-)\n```\n\n## [1.1.0] - 2026-01-07\n\n### Details of Changes\n\n```\n    commit b57e1f2 docs: fix admonitton support
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 09:39:44 2026 +0100
    
    
     docs/custom.css   | 20 ++++++++++++++++++++
     docs/lsp.md       |  3 +++
     docs/structure.md | 24 ++++++++++++++++++++++++
     mkdocs.yml        | 51 ++++++++++++++++++++++++++++++---------------------
     4 files changed, 77 insertions(+), 21 deletions(-)
    
    commit 161e136 docs: simplify documentation
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 08:45:33 2026 +0100
    
    
     docs/features.md     | 184 ++++++++++++++++++++++++++++++++------------
     docs/index.md        |  39 +++++-----
     docs/installation.md | 199 ++++++++++++------------------------------------
     docs/keymaps.md      | 109 ++++++++++++++++----------
     docs/lsp.md          | 100 ++++++++++++------------
     docs/plugins.md      | 211 ---------------------------------------------------
     docs/structure.md    | 207 ++++++++++++++++----------------------------------
     mkdocs.yml           |   1 -
     8 files changed, 384 insertions(+), 666 deletions(-)
    
    commit 2ac6d54 fix: keymaps overlaps with window menu
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 07:39:00 2026 +0100
    
    
     lua/llawn/config/keymaps.lua | 4 ++++
     1 file changed, 4 insertions(+)
    
    commit b7ee24b feat: clean log files on exit
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 07:38:08 2026 +0100
    
    
     lua/llawn/config/autocmd.lua | 24 ++++++++++++++++++++++++
     1 file changed, 24 insertions(+)
    
    commit 942b04e feat: undo files in an undodir directory
    Author: llawn <llawn06@gmail.com>
    Date: Wed Jan 7 07:36:02 2026 +0100
    
    - undo files are now in an ~/.undodir
    - add a :CleanUndo command to clean the directory
    
     lua/llawn/config/autocmd.lua | 14 ++++++++++++++
     lua/llawn/config/options.lua |  9 ++++++++-
     2 files changed, 22 insertions(+), 1 deletion(-)
    
    commit 94f9447 feat: first documentation
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 19:14:24 2026 +0100
    
    
     docs/features.md     | 153 ++++++++++++++++++++++
     docs/index.md        | 209 +++++++++---------------------
     docs/installation.md | 304 ++++++++++++++++++++++++++++++++++++++++++++
     docs/keymaps.md      | 234 ++++++++++++++++++++++++++++++++++
     docs/lsp.md          | 225 +++++++++++++++++++++++++++++++++
     docs/plugins.md      | 211 +++++++++++++++++++++++++++++++
     docs/structure.md    | 351 +++++++++++++++++++++++++++++++++++++++++++++++++++
     mkdocs.yml           |  30 ++++-
     8 files changed, 1568 insertions(+), 149 deletions(-)
    
    commit 4f4d25e feat: use mkdocs-material
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 19:08:45 2026 +0100
    
    
     .github/workflows/deploy.yml | 2 +-
     mkdocs.yml                   | 2 +-
     2 files changed, 2 insertions(+), 2 deletions(-)
    
    commit 9409b7d feat: documentation automation with a makefile
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 18:55:05 2026 +0100
    
    - add documentation description in readme
    
     .gitignore    |  1 +
     Makefile      | 16 ++++++++++++++++
     README.md     |  5 +++++
     docs/index.md |  5 +++++
     4 files changed, 27 insertions(+)
    
    commit 2b1f94d feat: documentation with mkdocs
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 18:38:15 2026 +0100
    
    
     .github/workflows/deploy.yml |  44 ++++++++++++
     docs/index.md                | 164 +++++++++++++++++++++++++++++++++++++++++++
     mkdocs.yml                   |   5 ++
     3 files changed, 213 insertions(+)
    
    commit e5f36d3 docs: add a badge in readme for neovim
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 17:32:43 2026 +0100
    
    
     README.md | 1 +
     1 file changed, 1 insertion(+)\n```\n\n## [1.0.0] - 2026-01-06\n\n### Details of Changes\n\n```\n    commit 4ae201d docs: add custom keymaps desc
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 17:23:13 2026 +0100
    
    
     README.md | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
     1 file changed, 54 insertions(+)
    
    commit 1633386 docs: add inspiration links
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 17:19:59 2026 +0100
    
    
     README.md | 6 ++++++
     1 file changed, 6 insertions(+)
    
    commit a90ee86 docs: update desc for after/lsp dir
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 17:16:47 2026 +0100
    
    
     README.md | 2 +-
     1 file changed, 1 insertion(+), 1 deletion(-)
    
    commit eec9e36 style: update readme table
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 17:14:05 2026 +0100
    
    
     README.md | 2 +-
     1 file changed, 1 insertion(+), 1 deletion(-)
    
    commit 7a784c1 docs: update init to not make info redundant with README
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 17:12:44 2026 +0100
    
    
     init.lua | 13 ++-----------
     1 file changed, 2 insertions(+), 11 deletions(-)
    
    commit d496110 docs: forget Mason in readme plugins
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 17:10:16 2026 +0100
    
    
     README.md | 6 +++++-
     1 file changed, 5 insertions(+), 1 deletion(-)
    
    commit cab8624 docs: update readme with better plugins information and new repo structure
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 17:06:36 2026 +0100
    
    
     README.md | 58 ++++++++++++++++++++++++++++++++++++++++------------------
     1 file changed, 40 insertions(+), 18 deletions(-)
    
    commit ae82bd7 feat: nvim-cmp support lsp configuration
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:55:42 2026 +0100
    
    
     lua/llawn/plugins/nvim-cmp.lua | 27 ++++++++++++++++-----------
     1 file changed, 16 insertions(+), 11 deletions(-)
    
    commit 3ca5bf4 docs: docs for telescope
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:55:17 2026 +0100
    
    
     lua/llawn/plugins/telescope.lua | 49 ++++++++++++++++++++++++-----------------
     1 file changed, 29 insertions(+), 20 deletions(-)
    
    commit 75b0dab docs: doc for undotree
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:55:06 2026 +0100
    
    
     lua/llawn/plugins/undotree.lua | 20 +++++++++++++++-----
     1 file changed, 15 insertions(+), 5 deletions(-)
    
    commit 6572e4e style: style for which-key
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:54:37 2026 +0100
    
    
     lua/llawn/plugins/which-key.lua | 14 ++++++++++++++
     1 file changed, 14 insertions(+)
    
    commit 0434a44 feat: yazi open in full window and can open lazygit
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:54:17 2026 +0100
    
    
     lua/llawn/plugins/yazi.lua | 61 ++++++++++++++++++++++++++--------------------
     1 file changed, 35 insertions(+), 26 deletions(-)
    
    commit ad67ae8 style: fix style for neogen
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:53:52 2026 +0100
    
    
     lua/llawn/plugins/neogen.lua | 55 ++++++++++++++++++++++++++------------------
     1 file changed, 32 insertions(+), 23 deletions(-)
    
    commit a4e1348 feat: lualine support LSP
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:53:28 2026 +0100
    
    
     lua/llawn/plugins/lualine.lua | 122 ++++++++++++++++++++++--------------------
     1 file changed, 63 insertions(+), 59 deletions(-)
    
    commit 513bf0c feat: lazygit now open in fullscreen and can open yazi directly
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:53:09 2026 +0100
    
    
     lua/llawn/plugins/lazygit.lua | 94 +++++++++++++++++++++++++------------------
     1 file changed, 55 insertions(+), 39 deletions(-)
    
    commit 991f032 style: fix style for harpoon
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:52:31 2026 +0100
    
    
     lua/llawn/plugins/harpoon.lua | 61 +++++++++++++++++++++++++++----------------
     1 file changed, 39 insertions(+), 22 deletions(-)
    
    commit be254eb feat: plugins for hexcolor picker and highlighter
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:52:05 2026 +0100
    
    
     lua/llawn/plugins/ccc.lua | 1 +
     1 file changed, 1 insertion(+)
    
    commit e49af40 style: fixing style in header
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:51:11 2026 +0100
    
    
     lua/llawn/plugins/lsp/cmp-nvim-lsp.lua | 4 ++--
     lua/llawn/plugins/lsp/mason.lua        | 1 +
     2 files changed, 3 insertions(+), 2 deletions(-)
    
    commit 38b4a8d style: missing space before @brief
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 16:47:42 2026 +0100
    
    
     lazy-lock.json                         | 35 +++++++++++++++-----
     lua/llawn/config/autocmd.lua           |  2 +-
     lua/llawn/config/globals.lua           |  2 +-
     lua/llawn/config/keymaps.lua           |  2 +-
     lua/llawn/config/lazy.lua              |  2 +-
     lua/llawn/config/lsp.lua               |  2 +-
     lua/llawn/config/menu.lua              |  2 +-
     lua/llawn/config/options.lua           |  3 +-
     lua/llawn/plugins/ccc.lua              | 20 ++++++++++++
     lua/llawn/plugins/colors.lua           | 59 ++++++++++++++++++++++-----------
     lua/llawn/plugins/harpoon.lua          | 25 ++++++++++----
     lua/llawn/plugins/lazygit.lua          | 27 ++++++++++++++-
     lua/llawn/plugins/lsp/cmp-nvim-lsp.lua | 28 ++++++++++++++++
     lua/llawn/plugins/lsp/mason.lua        | 46 ++++++++++++++++++++++++++
     lua/llawn/plugins/lualine.lua          | 21 ++++++++++--
     lua/llawn/plugins/neogen.lua           | 29 ++++++++++++++++
     lua/llawn/plugins/nvim-cmp.lua         | 60 ++++++++++++++++++++++++++++++++++
     lua/llawn/plugins/undotree.lua         |  8 +++++
     lua/llawn/plugins/which-key.lua        | 10 ------
     lua/llawn/plugins/yazi.lua             | 46 +++++++++++++++++---------
     20 files changed, 358 insertions(+), 71 deletions(-)
    
    commit 5efcbb9 enabling hints in lsp
    Author: llawn <llawn06@gmail.com>
    Date: Tue Jan 6 14:48:59 2026 +0100
    
    
     lua/llawn/config/lsp.lua | 2 +-
     1 file changed, 1 insertion(+), 1 deletion(-)
    
    commit 7455e2b move lsp to after dir
    Author: llawn <llawn06@gmail.com>
    Date: Mon Jan 5 16:15:31 2026 +0100
    
    
     after/lsp/flutter_ls.lua | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
     lsp/lua_ls.lua           | 29 ----------------------------
     lsp/pyright.lua          | 17 -----------------
     lsp/ruff.lua             | 20 --------------------
     4 files changed, 49 insertions(+), 66 deletions(-)
    
    commit 890a1c6 style: Update lsp.lua with some section style
    Author: llawn <151925221+llawn@users.noreply.github.com>
    Date: Fri Jan 2 12:51:01 2026 +0100
    
    
     lua/llawn/config/lsp.lua | 18 +++++++++---------
     1 file changed, 9 insertions(+), 9 deletions(-)
    
    commit f7ab971 feat: update all my config files
    Author: llawn <llawn06@gmail.com>
    Date: Fri Jan 2 12:43:45 2026 +0100
    
    improve style and commentary, rework some keymaps
    
     README.md                    |  34 +---------
     init.lua                     |   4 +-
     lua/llawn/config/autocmd.lua |  19 ++++--
     lua/llawn/config/globals.lua |  23 ++++++-
     lua/llawn/config/init.lua    |  10 +++
     lua/llawn/config/keymap.lua  |  50 ---------------
     lua/llawn/config/keymaps.lua | 144 +++++++++++++++++++++++++++++++++++++++++++
     lua/llawn/config/lazy.lua    |  38 +++++++++++-
     lua/llawn/config/lsp.lua     | 144 ++++++++++++++++++++++++++++++++++++-------
     lua/llawn/config/menu.lua    |  59 ++++++++++++++++++
     lua/llawn/config/options.lua |  41 +++++++-----
     lua/llawn/init.lua           |   7 +--
     12 files changed, 434 insertions(+), 139 deletions(-)
    
    commit 928d231 docs: add readme plugins links in README.md
    Author: llawn <llawn06@gmail.com>
    Date: Thu Jan 1 15:46:30 2026 +0100
    
    
     README.md | 11 ++++++++++-
     1 file changed, 10 insertions(+), 1 deletion(-)
    
    commit a186f12 fix: Update README.md
    Author: llawn <151925221+llawn@users.noreply.github.com>
    Date: Thu Jan 1 15:34:00 2026 +0100
    
    final fix for ASCII characters rendering in github
     README.md | 15 +++++++++------
     1 file changed, 9 insertions(+), 6 deletions(-)
    
    commit 775b8da fix: try fixing again ascii character
    Author: llawn <llawn06@gmail.com>
    Date: Thu Jan 1 15:30:12 2026 +0100
    
    
     README.md | 14 ++++++--------
     1 file changed, 6 insertions(+), 8 deletions(-)
    
    commit 2042a21 fix: ascii rendering in markdown
    Author: llawn <llawn06@gmail.com>
    Date: Thu Jan 1 15:28:31 2026 +0100
    
    
     README.md | 16 ++++++++--------
     1 file changed, 8 insertions(+), 8 deletions(-)
    
    commit 280dbc0 feat: better readme description
    Author: llawn <llawn06@gmail.com>
    Date: Thu Jan 1 15:26:10 2026 +0100
    
    
     README.md | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
     init.lua  | 28 +++++++++++++++++++
     2 files changed, 120 insertions(+), 2 deletions(-)\n```\n\n## [0.1.0] - 2025-11-06\n\n### Details of Changes\n\n```\n    commit 95f5b69 docs: add license and tags for readme
    Author: llawn <llawn06@gmail.com>
    Date: Thu Nov 6 11:41:47 2025 +0100
    
    
     LICENSE   | 21 +++++++++++++++++++++
     README.md |  4 ++++
     2 files changed, 25 insertions(+)
    
    commit f3471b2 docs: add a readme
    Author: llawn <llawn06@gmail.com>
    Date: Thu Nov 6 11:38:26 2025 +0100
    
    
     README.md | 3 +++
     1 file changed, 3 insertions(+)
    
    commit 9533b8f feat: add lsp
    Author: llawn <llawn06@gmail.com>
    Date: Thu Nov 6 11:34:44 2025 +0100
    
    
     lazy-lock.json  | 12 ++++++++++++
     lsp/lua_ls.lua  | 29 +++++++++++++++++++++++++++++
     lsp/pyright.lua | 17 +++++++++++++++++
     lsp/ruff.lua    | 20 ++++++++++++++++++++
     4 files changed, 78 insertions(+)
    
    commit 5b68c34 feat: add plugins
    Author: llawn <llawn06@gmail.com>
    Date: Thu Nov 6 11:34:20 2025 +0100
    
    
     lua/llawn/plugins/colors.lua    | 27 +++++++++++++++++++++++
     lua/llawn/plugins/harpoon.lua   | 21 ++++++++++++++++++
     lua/llawn/plugins/lazygit.lua   | 20 +++++++++++++++++
     lua/llawn/plugins/lualine.lua   | 49 +++++++++++++++++++++++++++++++++++++++++
     lua/llawn/plugins/telescope.lua | 25 +++++++++++++++++++++
     lua/llawn/plugins/which-key.lua | 18 +++++++++++++++
     lua/llawn/plugins/yazi.lua      | 43 ++++++++++++++++++++++++++++++++++++
     7 files changed, 203 insertions(+)
    
    commit 106f0e1 feat: nvim custom configuration
    Author: llawn <llawn06@gmail.com>
    Date: Thu Nov 6 11:33:35 2025 +0100
    
    
     init.lua                     |  1 +
     lua/llawn/config/autocmd.lua |  8 +++++++
     lua/llawn/config/globals.lua | 11 ++++++++++
     lua/llawn/config/keymap.lua  | 50 ++++++++++++++++++++++++++++++++++++++++++++
     lua/llawn/config/lazy.lua    | 22 +++++++++++++++++++
     lua/llawn/config/lsp.lua     | 34 ++++++++++++++++++++++++++++++
     lua/llawn/config/options.lua | 48 ++++++++++++++++++++++++++++++++++++++++++
     lua/llawn/init.lua           |  6 ++++++
     8 files changed, 180 insertions(+)\n```\n\n
