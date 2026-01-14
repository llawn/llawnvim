# Changelog

## [1.3.1] - 2026-01-14

### Documentation
- Added CHANGELOG.md file

## [1.3.0] - 2026-01-14

### Added
- Menu system for various Neovim features

### Changed
- Updated LSP, menu, and plugin configurations

### Fixed
- Treesitter when language has no parsers available

### Refactored
- Reorganized quit logic for better modularity

### Details of Changes

Below is a detailed view of the changes between tags 1.2.2 and 1.3.0:

```
commit 1de7368 feat: update LSP, menu, and plugin configurations
Author: llawn <llawn06@gmail.com>
Date:   Wed Jan 14 17:56:12 2026 +0100

 lua/llawn/config/options.lua | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 95141bf refactor: reorganize quit logic for better modularity
Author: llawn <llawn06@gmail.com>
Date:   Wed Jan 14 17:56:12 2026 +0100

 lua/llawn/config/options.lua | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

commit 9e39512 feat: add menu system for various Neovim features
Author: llawn <llawn06@gmail.com>
Date:   Wed Jan 14 17:56:12 2026 +0100

 lua/llawn/plugins/menu.lua | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

commit e9e3cc4 fix: fix treesitter when lang has no parsers available
Author: llawn <llawn06@gmail.com>
Date:   Wed Jan 14 17:56:12 2026 +0100

 lua/llawn/config/treesitter.lua | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
```

All commits and tags are now GPG-signed.