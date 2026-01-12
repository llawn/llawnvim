--- @brief Plugin configuration for nvim-cmp
--- nvim-cmp is a completion engine for Neovim that provides intelligent autocompletion
--- from various sources like LSP, snippets, buffer text, and file paths
---

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- Load on entering insert mode
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*",
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
    config = function()
      -- Require necessary modules
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local colors = require("llawn.plugins.local.telescope_color_picker")

       -- Register custom colors completion source
       cmp.register_source("colors", {
         keyword_pattern = [[\k\+]],
         complete = function(self, params, callback)
           local items = {}
           local input = params.option.keyword or ""
           for name, hex in pairs(colors) do
             if name:lower():sub(1, #input) == input:lower() then
               table.insert(items, {
                 label = name,
                 insertText = hex:lower(),
                 kind = cmp.lsp.CompletionItemKind.Color,
               })
             end
           end
           callback(items)
         end,
       })

      -- Load VSCode-style snippets from installed plugins
      require("luasnip.loaders.from_vscode").lazy_load()

     -- Configure nvim-cmp completion engine
     cmp.setup({
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
       -- sources for autocompletion
       sources = cmp.config.sources({
         { name = "nvim_lsp" },
         { name = "luasnip" }, -- snippets
         { name = "colors" }, -- standard hex colors
         { name = "buffer" }, -- text within current buffer
         { name = "path" }, -- file system paths
       }),

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
}
