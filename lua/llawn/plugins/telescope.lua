return {
    'nvim-telescope/telescope.nvim', 
      dependencies = { 'nvim-lua/plenary.nvim' },
     config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')

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
