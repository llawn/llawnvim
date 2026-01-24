--- Defines automatic actions triggered by Neovim events

-- ============================================================================
-- Highlight on Yank
-- ============================================================================

-- Briefly highlights the region of text that was just yanked (copied).
vim.api.nvim_create_autocmd(
  "TextYankPost",
  {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup(
      "highlight-yank",
      { clear = true }
    ),
    callback = function() vim.highlight.on_yank() end,
  }
)

-- ============================================================================
-- Clean Undo Files Command
-- ============================================================================

--- Clean undo files
--- @return nil
local function clean_undofiles()
  local undodir = vim.fn.expand("~/.local/state/nvim/undo", true)
  if vim.fn.isdirectory(undodir) == 1 then
    vim.fn.system("rm -rf " .. undodir .. "/*")
    vim.notify("Undo files cleaned.", vim.log.levels.INFO)
  else
    vim.notify("Undodir does not exist.", vim.log.levels.WARN)
  end
end

vim.api.nvim_create_user_command(
  "CleanUndo",
  clean_undofiles,
  { desc = "Clean all persistent undo files" }
)

-- ============================================================================
-- Clean Log Files on Exit
-- ============================================================================

--- Clean log files
--- @return nil
local function clean_log_files()
  local log_dir = vim.fn.expand("~/.local/state/nvim")
  -- Delete all .log files
  local log_files = vim.fn.glob(log_dir .. "/*.log", false, true)
  for _, path in ipairs(log_files) do
    if vim.fn.filereadable(path) == 1 then
      vim.fn.delete(path)
    end
  end
  -- Also delete the "log" file if it exists
  local general_log = log_dir .. "/log"
  if vim.fn.filereadable(general_log) == 1 then
    vim.fn.delete(general_log)
  end
end

vim.api.nvim_create_autocmd(
  "VimLeave",
  {
    desc = "Clean Neovim log files on exit to prevent them from growing too large",
    group = vim.api.nvim_create_augroup("clean-logs-on-exit", { clear = true }),
    callback = clean_log_files
  }
)

-- ============================================================================
-- Alpha Dashboard on Startup
-- ============================================================================

--- Start alpha dashboard
--- @return nil
local function start_alpha_dashboard()
  if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
    require("alpha").start()
  end
end

vim.api.nvim_create_autocmd(
  "VimEnter",
  {
    desc = "Show alpha dashboard when starting Neovim without arguments",
    group = vim.api.nvim_create_augroup("alpha-dashboard", { clear = true }),
    callback = start_alpha_dashboard
  }
)

-- ============================================================================
-- Diagnostic Keymaps
-- ============================================================================

--- Setup diagnostic keymaps after Neovim is fully initialized
--- @return nil
local function setup_diagnostic_keymaps()
  local diag = require("llawn.config.diag")
  diag.setup_global_diagnostic_keymaps()
end

vim.api.nvim_create_autocmd(
  "VimEnter",
  {
    desc = "Setup global diagnostic keymaps after initialization",
    group = vim.api.nvim_create_augroup("setup-diagnostic-keymaps", { clear = true }),
    callback = setup_diagnostic_keymaps,
    once = true
  }
)
