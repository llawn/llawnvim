--- @brief Color picker and highlighter plugin configuration for Neovim
--- Provides color preview, manipulation, and highlighting features

return {
    "uga-rosa/ccc.nvim",
    config = function()
        local ccc = require("ccc")
        ccc.setup({
            -- Configuration options can be added here
            highlighter = {
                auto_enable = true,
                lsp = true,
            },
        })

        -- Keybindings for color picker
        vim.keymap.set("n", "<leader>cc", "<cmd>CccPick<cr>", { desc = "Color picker" })
        vim.keymap.set("n", "<leader>ct", "<cmd>CccHighlighterToggle<cr>", { desc = "Toggle color highlighter" })
    end
}
