-- ============================================================================
--    ██╗     ██╗      █████╗ ██╗    ██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
--    ██║     ██║     ██╔══██╗██║    ██║████╗  ██║██║   ██║██║████╗ ████║
--    ██║     ██║     ███████║██║ █╗ ██║██╔██╗ ██║██║   ██║██║██╔████╔██║
--    ██║     ██║     ██╔══██║██║███╗██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
--    ███████╗███████╗██║  ██║╚███╔███╔╝██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
--    ╚══════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
--                                                                                                          
-- LLawn Neovim Configuration
-- ============================================================================

-- This file loads the "llawn" module, which contains my main
-- Neovim configuration. If needed, I can switch configuration by
-- loading another module (e.g "theprimeagen") 
--
-- Structure of the `llawn` folder:
--   lua/llawn/
--     ├─ config/    → LSP, keymaps, menus, autocmds, options
--     └─ plugins/   → plugin configurations
--
-- Note:
--   - Uses Lazy as the package manager
--   - All LSP configurations use Neovim 0.11+ `vim.lsp.enable` API
--
-- ============================================================================
require("llawn")

