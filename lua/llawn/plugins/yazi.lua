--- @brief Yazi plugin configuration for file management in Neovim
--- Provides keybindings for opening Yazi file manager

---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
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
   ---@type YaziConfig
   opts = {
     -- fullscreen floating window
     floating_window_scaling_factor = 1.0,
     yazi_floating_window_border = "none",
     yazi_floating_window_winblend = 0,
     yazi_floating_window_zindex = 50,

     -- overwrite netrw
     open_for_directories = true,
     file_filter = function(entry)
       return true
     end,
      keymaps = {
        show_help = "<f1>",
      },
      hooks = {
         on_yazi_ready = function()
           vim.schedule(function()
             if vim.fn.exists(':LazyGit') == 2 then
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
