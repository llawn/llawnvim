--- @brief Yazi plugin configuration for file management in Neovim
--- Provides keybindings for opening Yazi file manager
---

return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  -- Keybindings for opening Yazi file manager
  keys = {
    {
      "<leader>-",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  -- Configuration options for Yazi plugin
  opts = {
    -- Fullscreen floating window settings
    floating_window_scaling_factor = 1.0,
    yazi_floating_window_border = "none",
    yazi_floating_window_winblend = 0,
    yazi_floating_window_zindex = 50,

    -- Overwrite netrw for directory opening
    open_for_directories = true,
    file_filter = function(entry)
      return true
    end,
    keymaps = {
      show_help = "<f1>",
    },
    hooks = {
      yazi_opened = function() end,
      yazi_closed_successfully = function() end,
      yazi_opened_multiple_files = function() end,
      -- Hook called when Yazi is fully initialized and ready
      on_yazi_ready = function()
        -- Defer execution to ensure Neovim is ready for keymap setup
        vim.schedule(function()
          -- Check if LazyGit command is available (exists as a user-defined command)
          if vim.fn.exists(':LazyGit') == 2 then
            -- Set up terminal keybinding to close Yazi and open LazyGit
            -- <c-l> in terminal mode: exit insert mode, quit Yazi, then launch LazyGit
            vim.keymap.set('t', '<c-l>', '<C-\\><C-n>:q<CR>:LazyGit<CR>', { buffer = true, desc = "Open LazyGit" })
          end
        end)
      end,
    },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 0
  end,
}
