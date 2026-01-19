-- Plugin: nvim-cmp
-- Description: Generates docstrings for functions and types with Treesitter and LuaSnip integration

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",  -- Load on entering insert mode
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path",   -- source for file system paths
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*",
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip",     -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim",         -- vs-code like pictograms
  },
  config = function()
    -- Require necessary modules
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    local colors = require("llawn.colors.telescope_color_picker")
    local colors_utils = require('llawn.colors.colors_utils')

    -- Register custom colors completion source
    local source = {}

    function source:complete(params, callback)
      local items = {}
      -- Use params.context.cursor_before_line to get the current word
      local input = params.context.cursor_before_line:match("[%w_]+$") or ""

      for name, hex in pairs(colors) do
        if name:lower():sub(1, #input) == input:lower() then
          table.insert(items, {
            label = name,
            insertText = hex:lower(),
            kind = cmp.lsp.CompletionItemKind.Color,
            documentation = hex, -- Adds a preview of the hex code
          })
        end
      end
      callback(items)
    end

    function source:get_keyword_pattern()
      return [[\k\+]]
    end

    cmp.register_source("colors", source)

    -- Load VSCode-style snippets from installed plugins
    require("luasnip.loaders.from_vscode").lazy_load()

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
        ["<C-e>"] = cmp.mapping.abort(),        -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- snippets
        { name = "colors" },  -- standard hex colors
        { name = "buffer" },  -- text within current buffer
        { name = "path" },    -- file system paths
      }),

      formatting = {
        format = function(entry, vim_item)
          -- Apply standard lspkind formatting
          vim_item = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
          })(entry, vim_item)

          -- CUSTOM HIGHLIGHT LOGIC
          if entry.source.name == "colors" or vim_item.kind == "Color" then
            local hex = entry.completion_item.documentation or entry.completion_item.label

            -- Ensure hex is a string
            if type(hex) == "string" then
              local color_int = colors_utils.hex_to_int(hex)

              if color_int then
                -- Create a unique highlight group name for this color
                local hl_group = string.format("CmpColor_%06x", color_int)

                -- Calculate FG (Black or White) based on luminance just like your highlighter
                local r, g, b = colors_utils.int_to_rgb(color_int)
                local luminance = colors_utils.relative_luminance(r, g, b)
                local fg = luminance > 0.5 and "#000000" or "#ffffff"

                -- Create the highlight group
                vim.api.nvim_set_hl(0, hl_group, { fg = fg, bg = hex })

                -- Apply it to the menu (documentation)
                vim_item.menu = hex
                vim_item.menu_hl_group = hl_group
              end
            end
          end

          return vim_item
        end,
      },
    })
  end,
}
