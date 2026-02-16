-- All the menu

local M = {}

-- Helper to safely load modules that might have different return structures
local function safe_load(path, sub_key)
  local ok, mod = pcall(require, path)
  if not ok then
    vim.notify("Menu Error: Could not load " .. path, vim.log.levels.ERROR)
    return nil
  end
  -- Return the sub-table if it exists, otherwise return the module itself
  return (sub_key and mod[sub_key]) and mod[sub_key] or mod
end

M.window     = safe_load('llawn.config.menu.window', 'window')
M.treesitter = safe_load('llawn.config.menu.treesitter', 'treesitter')
M.mason      = safe_load('llawn.config.menu.mason', 'mason')
M.ts_symbols = safe_load('llawn.config.menu.treesitter_symbols', 'ts_symbols')
M.unsaved    = safe_load('llawn.config.menu.unsaved', 'unsaved')
M.swapfiles  = safe_load('llawn.config.menu.swapfiles', 'swapfiles')
M.lint       = safe_load('llawn.config.menu.lint', 'lint')
M.quit       = safe_load('llawn.config.menu.quit', 'quit')

return M
