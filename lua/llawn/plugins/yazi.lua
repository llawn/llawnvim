-- Plugin: mikavilpas/yazi.nvim
-- Description: Yazi is a terminal file manager written in Rust,
--              providing a fast and efficient way to navigate and manage files in Neovim.

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
      desc = "Yazi File",
    },
    {
      "<leader>y",
      "<cmd>Yazi cwd<cr>",
      desc = "Yazi CWD",
    },
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Yazi Toggle",
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
    file_filter = function(_)
      return true
    end,
    keymaps = {
      show_help = "<f1>",
    },
    hooks = {
      yazi_opened = function()
        vim.notify("Yazi opened - setting up keymaps", vim.log.levels.INFO)
        vim.schedule(function()
          vim.keymap.set('t', '<c-l>', '<C-\\><C-n>:q<CR>:LazyGit<CR>', {
            buffer = true,
            desc = "Open LazyGit"
          })
        end)
      end,
      yazi_closed_successfully = function() end,
      yazi_opened_multiple_files = function() end,
    },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 0
  end,
}
