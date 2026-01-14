local function save_treesitter_lock()

  local parsers = require('nvim-treesitter.parsers')
  local configs = parsers.get_parser_configs()
  local utils = require('nvim-treesitter.utils')
  local ts_configs = require('nvim-treesitter.configs')

  local function get_installed_revision(lang)
    local parser_info_dir = ts_configs.get_parser_info_dir()
    if not parser_info_dir then
      return nil
    end
    local lang_file = utils.join_path(parser_info_dir, lang .. ".revision")
    if vim.fn.filereadable(lang_file) == 1 then
      return vim.fn.readfile(lang_file)[1]
    end
  end

  local data = {}
  for name, _ in pairs(configs) do
    if parsers.has_parser(name) then
      local commit = get_installed_revision(name) or 'unknown'
      table.insert(data, {
        name = name,
        commit = commit,
      })
    end
  end

  table.sort(data, function(a, b) return a.name < b.name end)
  local json_lines = {"["}
  for i, entry in ipairs(data) do
    local entry_str = vim.fn.json_encode(entry)
    table.insert(json_lines, "  " .. entry_str .. (i < #data and "," or ""))
  end
  table.insert(json_lines, "]")
  local path = vim.fn.stdpath('config') .. '/treesitter-lock.json'
  vim.fn.writefile(json_lines, path)
end

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

    -- Save lock on TSUpdate
    vim.api.nvim_create_autocmd('User', {
      pattern = { 'TSUpdate', 'TSInstall', 'TSUninstall' },
      callback = save_treesitter_lock,
    })

    -- Save on VimEnter
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = save_treesitter_lock,
    })

    -- Auto-install parser if not available
    vim.api.nvim_create_autocmd('BufReadPost', {
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype
        if ft == '' then return end
        local lang = vim.treesitter.language.get_lang(ft)
        if lang and require('nvim-treesitter.parsers').get_parser_configs()[lang] and not require('nvim-treesitter.parsers').has_parser(lang) then
          local choice = vim.fn.confirm('Install treesitter parser for ' .. lang .. '?', '&Yes\n&No', 1)
          if choice == 1 then
            vim.cmd('TSInstall ' .. lang)
          end
        end
      end,
    })
  end,
}
