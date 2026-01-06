--- @brief LazyGit plugin configuration for Git integration in Neovim
--- Provides keybindings for launching LazyGit interface

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
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    },
    config = function()
        vim.env.GPG_TTY = vim.fn.system('tty'):gsub('\n', '')
        vim.g.lazygit_floating_window_scaling_factor = 1.0
        vim.g.lazygit_floating_window_winblend = 0
        vim.g.lazygit_floating_window_zindex = 100
        vim.api.nvim_create_autocmd("TermOpen", {
            callback = function()
                if vim.bo.filetype == 'lazygit' then
                    print("LazyGit TermOpen triggered")
                    vim.keymap.set('t', 'x', '<C-\\><C-n>:q<CR>:Yazi<CR>', { buffer = true, desc = "Close LazyGit and open Yazi" })
                    local buf = vim.api.nvim_get_current_buf()
                    vim.defer_fn(function()
                        local winid = vim.fn.bufwinid(buf)
                        if winid ~= -1 then
                            vim.api.nvim_set_current_win(winid)
                            vim.cmd('startinsert')
                        end
                    end, 100)
                end
            end
        })
    end,
}
