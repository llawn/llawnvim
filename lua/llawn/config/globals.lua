--- Defines global Vim variables used across the Neovim configuration
--- Includes leader keys, built-in plugin settings, and UI capabilities

-- ============================================================================
-- Leader Keys
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Netrw (Built-in File Explorer)
-- ============================================================================
-- Netrw is kept minimal since it is replaced by yazi

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- ============================================================================
-- UI / Fonts
-- ============================================================================

vim.g.have_nerd_font = true
