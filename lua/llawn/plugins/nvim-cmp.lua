-- Plugin: nvim-cmp
-- Description: Generates docstrings for functions and types with Treesitter and LuaSnip integration

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- Load on entering insert mode
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    "hrsh7th/cmp-cmdline", -- source for command line completion
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
    local cmp_colors = require("colors.cmp_colors")

    -- Load VSCode-style snippets from installed plugins
    require("luasnip.loaders.from_vscode").lazy_load()

    -- colors.nvim completion
    cmp_colors.setup()

    -- Configure nvim-cmp completion engine
    cmp.setup({
      snippet = {
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
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
        { name = "colors" }, -- colors.nvim
      }),

      formatting = {
        format = function(entry, vim_item)
          -- Apply standard lspkind formatting
          vim_item = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
          })(entry, vim_item)

          vim_item = cmp_colors.format(entry, vim_item)

          return vim_item
        end,
      },
    })

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        { name = "palette_colors" },
        { name = "cmdline" },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })
  end,
}
