 return {
    "llawn-ai/llawn.ai",
    -- While developing, point to the local path:
    dir = "~/Source/llawn.ai",
    -- When published, you'll use: name/repo-name
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        local llawn_ai = require("llawn_ai")
        llawn_ai.setup()

        -- Keymap for hello world
        vim.keymap.set("n", "<leader>lh", function() llawn_ai.hello() end, { desc = "Hello from llawn.ai" })

        -- Keymap for AI fill function
        vim.keymap.set("n", "<leader>lf", function() llawn_ai.fill_function() end, { desc = "AI fill function" })
    end,
}
