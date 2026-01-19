-- Plugin: LazyGit
-- Description: Integrates LazyGit, a simple terminal UI for git commands, into Neovim
--              Provides seamless git management with keybindings for various LazyGit modes
--              Supports floating windows and custom configurations for enhanced workflow

return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },

  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- setting the keybinding for LazyGit
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
  },
  --- Configuration function for lazygit
  config = function()
    vim.g.lazygit_floating_window_scaling_factor = 1.0
    vim.g.lazygit_floating_window_winblend = 0
    vim.g.lazygit_floating_window_zindex = 100
    -- Set GPG_TTY environment variable for proper GPG operations in lazygit
    vim.env.GPG_TTY = vim.fn.system('tty'):gsub('\n', '')
    -- Applies custom configuration only to lazygit terminal buffers
    vim.api.nvim_create_autocmd(
      "TermOpen",
      {
        callback = function()
          if vim.bo.filetype == 'lazygit' then
            -- Set terminal mode keymap: 'x' to exit lazygit and launch Yazi file manager
            vim.keymap.set(
              't',
              '<c-x>',
              '<C-\\><C-n>:q<CR>:Yazi<CR>',
              { buffer = true, desc = "Quit to Yazi" }
            )
            local buf = vim.api.nvim_get_current_buf()
            -- Defer execution by 100ms to ensure window setup is complete
            -- Then switch to the lazygit window and enter insert mode for interaction
            vim.defer_fn(
              function()
                local winid = vim.fn.bufwinid(buf)
                if winid ~= -1 then
                  vim.api.nvim_set_current_win(winid)
                  vim.cmd('startinsert')
                end
              end,
              100
            )
          end
        end
      }
    )
  end,
}
