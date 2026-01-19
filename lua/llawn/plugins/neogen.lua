-- Plugin: Neogen
-- Description: Generates docstrings for functions and types with Treesitter and LuaSnip integration

return {
  "danymat/neogen",
  description = "Generate annotations (docstrings) for functions and types using Treesitter and LuaSnip",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Required for syntax parsing
    "L3MON4D3/LuaSnip",                -- Required for snippet engine
  },
  config = function()
    -- Setup neogen with LuaSnip as the snippet engine
    local neogen = require("neogen")

    neogen.setup({
      snippet_engine = "luasnip"
    })

    -- Generate function docstring
    vim.keymap.set(
      "n",
      "<leader>pd",
      function() neogen.generate({ type = "func" }) end,
      { desc = "Function Doc" }
    )

    -- Generate type/class docstring
    vim.keymap.set(
      "n",
      "<leader>pt",
      function() neogen.generate({ type = "type" }) end,
      { desc = "Type Doc" }
    )
  end,
}
