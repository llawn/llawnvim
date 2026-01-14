--- @brief Provides UI menus in Neovim.
---

local M = {}

-- Load menu modules
local window = require('llawn.config.menu.window')
local git = require('llawn.config.menu.git')
local treesitter = require('llawn.config.menu.treesitter')
local mason = require('llawn.config.menu.mason')
local unsaved = require('llawn.config.menu.unsaved')
local swapfiles = require('llawn.config.menu.swapfiles')
local quit = require('llawn.config.menu.quit')

-- Assign to M
M.window = window.window
M.git = git.git
M.treesitter = treesitter.treesitter
M.mason = mason.mason
M.unsaved = unsaved.unsaved
M.swapfiles = swapfiles.swapfiles
M.quit = quit.quit

return M
