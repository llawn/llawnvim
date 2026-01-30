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
  local ok, diag = pcall(require, "llawn.config.diag")
  if ok and diag.setup_global_diagnostic_keymaps then
    diag.setup_global_diagnostic_keymaps()
  else
    vim.notify("Failed to load diagnostic module", vim.log.levels.ERROR)
  end
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

-- ============================================================================
-- Yazi Transition Keymaps
-- ============================================================================

vim.api.nvim_create_autocmd("FileType", {
  pattern = "yazi",
  desc = "Setup keymaps for Yazi terminal buffers",
  group = vim.api.nvim_create_augroup("yazi-keymaps", { clear = true }),
  callback = function(event)
    local yazi_buf = event.buf
    vim.bo[yazi_buf].bufhidden = "hide"

    -- Generic Transition: Just hides Yazi and runs the command
    local function simple_transition(cmd_func)
      vim.cmd("stopinsert")
      vim.api.nvim_win_hide(0)
      vim.defer_fn(function()
        cmd_func()
      end, 100)
    end

    -- Telescope Transition: Adds the "Return to Yazi on Esc" logic
    local function telescope_transition(picker_func)
      vim.cmd("stopinsert")
      vim.api.nvim_win_hide(0)
      vim.defer_fn(function()
        picker_func({
          attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            local restore_yazi = function()
              actions.close(prompt_bufnr)
              vim.schedule(function()
                vim.cmd("Yazi")
              end)
            end
            map("i", "<Esc>", restore_yazi)
            map("n", "<Esc>", restore_yazi)
            return true
          end,
        })
      end, 100)
    end

    -- Standard Telescope Pickers (With "Esc to Yazi" support)
    local tele_maps = {
      ['<A-g>'] = function(opts) require('telescope').extensions.live_grep_args.live_grep_args(opts) end,
      ['<A-p>'] = function(opts) require('telescope').extensions.project.project(opts) end,
      ['<A-b>'] = function(opts)
        local theme = require('telescope.themes').get_dropdown({ previewer = false, initial_mode = "insert" })
        require('telescope.builtin').buffers(vim.tbl_deep_extend("force", theme, opts))
      end,
    }

    for key, func in pairs(tele_maps) do
      vim.keymap.set('t', key, function()
        telescope_transition(func)
      end, { buffer = yazi_buf, silent = true })
    end

    -- Harpoon
    vim.keymap.set('t', '<A-e>', function()
      simple_transition(function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
    end, { buffer = yazi_buf, silent = true, desc = "Harpoon" })

    -- LazyGit
    vim.keymap.set('t', '<A-l>', function()
      simple_transition(function()
        vim.cmd("LazyGit")
      end)
    end, { buffer = yazi_buf, silent = true, desc = "LazyGit" })

    -- Unsaved Files
    vim.keymap.set('t', '<A-u>', function()
      simple_transition(function()
        require('llawn.config.menu').unsaved.menu()
      end)
    end, { buffer = yazi_buf, silent = true })

    -- Git Status
    vim.keymap.set('t', '<A-s>', function()
      simple_transition(function()
        require('llawn.config.menu').git.status_menu()
      end)
    end, { buffer = yazi_buf, silent = true })
  end,
})
