return {
    "danymat/neogen",
    description = "Generate annotations (docstrings) for functions and types using Treesitter and LuaSnip",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "L3MON4D3/LuaSnip",
    },
    config = function()
        local neogen = require("neogen")

        neogen.setup({
            snippet_engine = "luasnip"
        })

        -- Generate function docstring
        vim.keymap.set("n", "<leader>nf", function()
            neogen.generate({ type = "func" })
        end, { desc = "Generate function docstring" })

        -- Generate type/class docstring
        vim.keymap.set("n", "<leader>nt", function()
            neogen.generate({ type = "type" })
        end, { desc = "Generate type/class docstring" })

    end,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
}

