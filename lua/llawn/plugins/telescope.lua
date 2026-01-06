--- @brief Plugin configuration for telescope
--- telescope is a highly extendable fuzzy finder for Neovim
--- Provides powerful search and navigation capabilities
---

return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' }, -- Required utility functions
  config = function()
    -- Basic telescope setup with default configuration
    require('telescope').setup({})

    -- Load builtin functions
    local builtin = require('telescope.builtin')

    -- Telescope keybindings for various search functions

    vim.keymap.set('n', '<leader>tf', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>tg', builtin.git_files, { desc = 'Telescope git files' })
    vim.keymap.set('n', '<leader>tb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>th', builtin.help_tags, { desc = 'Telescope help tags' })

    -- Search the current word under the cursor
    vim.keymap.set(
      'n',
      '<leader>tw',
      function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = word })
      end,
      { desc = 'Telescope find word' }
    )
  end
}
