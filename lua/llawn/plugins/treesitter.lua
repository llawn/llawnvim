return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'lua',
        'vim',
        'vimdoc',
        'query',
        'json',
        'markdown',
        'markdown_inline',
      },
      sync_install = false,
      ignore_install = {},
      auto_install = false,
      modules = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
            ['ai'] = '@conditional.outer',
            ['ii'] = '@conditional.inner',
            ['as'] = '@statement.outer',
            ['is'] = '@statement.inner',
            ['am'] = '@call.outer',
            ['im'] = '@call.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
            [']l'] = '@loop.outer',
            [']a'] = '@parameter.outer',
            [']b'] = '@block.outer',
            [']i'] = '@conditional.outer',
            [']s'] = '@statement.outer',
            [']m'] = '@call.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@class.outer',
            [']L'] = '@loop.outer',
            [']A'] = '@parameter.outer',
            [']B'] = '@block.outer',
            [']I'] = '@conditional.outer',
            [']S'] = '@statement.outer',
            [']M'] = '@call.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
            ['[l'] = '@loop.outer',
            ['[a'] = '@parameter.outer',
            ['[b'] = '@block.outer',
            ['[i'] = '@conditional.outer',
            ['[s'] = '@statement.outer',
            ['[m'] = '@call.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@class.outer',
            ['[L'] = '@loop.outer',
            ['[A'] = '@parameter.outer',
            ['[B'] = '@block.outer',
            ['[I'] = '@conditional.outer',
            ['[S'] = '@statement.outer',
            ['[M'] = '@call.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>sp'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>sP'] = '@parameter.inner',
          },
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
    })

    -- Auto-install parser if not available
    vim.api.nvim_create_autocmd('BufReadPost', {
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype
        if ft == '' then return end
        local lang = vim.treesitter.language.get_lang(ft)
        if lang and not require('nvim-treesitter.parsers').has_parser(lang) then
          local choice = vim.fn.confirm('Install treesitter parser for ' .. lang .. '?', '&Yes\n&No', 1)
          if choice == 1 then
            vim.cmd('TSInstall ' .. lang)
          end
        end
      end,
    })
  end,
}
