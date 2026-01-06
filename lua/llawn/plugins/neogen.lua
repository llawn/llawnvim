--- @brief Plugin configuration for neogen
--- neogen is a Neovim plugin that generates docstrings (annotations) for functions and types
--- It uses Treesitter for parsing and LuaSnip for snippet insertion
--- 

return {
  "danymat/neogen",
  description = "Generate annotations (docstrings) for functions and types using Treesitter and LuaSnip",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Required for syntax parsing
    "L3MON4D3/LuaSnip", -- Required for snippet engine
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
      "<leader>nf",
      function() neogen.generate({ type = "func" }) end,
      { desc = "Generate function docstring" }
    )

    -- Generate type/class docstring
    vim.keymap.set(
      "n",
      "<leader>nt",
      function() neogen.generate({ type = "type" }) end,
      { desc = "Generate type/class docstring" }
    )
  end,
}

