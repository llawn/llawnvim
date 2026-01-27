-- Plugin: Treesitter (TS)
-- Description: TS is a parser generator tool and an incremental parsing library.
--              It can build a concrete syntax tree for a source file and efficiently
--              update the syntax tree as the source file is edited.

-- Save TS parser information to the root nvim config as a "lock" file
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
  local json_lines = { "[" }
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
            ['aa'] = { query = '@parameter.outer', desc = 'Around parameter' },
            ['ab'] = { query = '@block.outer', desc = 'Around block' },
            ['ac'] = { query = '@class.outer', desc = 'Around class' },
            ['af'] = { query = '@function.outer', desc = 'Around function' },
            ['ai'] = { query = '@conditional.outer', desc = 'Around conditional' },
            ['al'] = { query = '@loop.outer', desc = 'Around loop' },
            ['am'] = { query = '@call.outer', desc = 'Around call' },
            ['as'] = { query = '@statement.outer', desc = 'Around statement' },
            ['ia'] = { query = '@parameter.inner', desc = 'Inside parameter' },
            ['ib'] = { query = '@block.inner', desc = 'Inside block' },
            ['ic'] = { query = '@class.inner', desc = 'Inside class' },
            ['if'] = { query = '@function.inner', desc = 'Inside function' },
            ['ii'] = { query = '@conditional.inner', desc = 'Inside conditional' },
            ['il'] = { query = '@loop.inner', desc = 'Inside loop' },
            ['im'] = { query = '@call.inner', desc = 'Inside call' },
            ['is'] = { query = '@statement.inner', desc = 'Inside statement' },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']a'] = { query = '@parameter.outer', desc = 'Next parameter' },
            [']b'] = { query = '@block.outer', desc = 'Next block' },
            [']c'] = { query = '@class.outer', desc = 'Next class' },
            [']f'] = { query = '@function.outer', desc = 'Next function' },
            [']i'] = { query = '@conditional.outer', desc = 'Next conditional' },
            [']l'] = { query = '@loop.outer', desc = 'Next loop' },
            [']m'] = { query = '@call.outer', desc = 'Next call' },
            [']s'] = { query = '@statement.outer', desc = 'Next statement' },
          },
          goto_next_end = {
            [']A'] = { query = '@parameter.outer', desc = 'Next parameter end' },
            [']B'] = { query = '@block.outer', desc = 'Next block end' },
            [']C'] = { query = '@class.outer', desc = 'Next class end' },
            [']F'] = { query = '@function.outer', desc = 'Next function end' },
            [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
            [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
            [']M'] = { query = '@call.outer', desc = 'Next call end' },
            [']S'] = { query = '@statement.outer', desc = 'Next statement end' },
          },
          goto_previous_start = {
            ['[a'] = { query = '@parameter.outer', desc = 'Prev parameter' },
            ['[b'] = { query = '@block.outer', desc = 'Prev block' },
            ['[c'] = { query = '@class.outer', desc = 'Prev class' },
            ['[f'] = { query = '@function.outer', desc = 'Prev function' },
            ['[i'] = { query = '@conditional.outer', desc = 'Prev conditional' },
            ['[l'] = { query = '@loop.outer', desc = 'Prev loop' },
            ['[m'] = { query = '@call.outer', desc = 'Prev call' },
            ['[s'] = { query = '@statement.outer', desc = 'Prev statement' },
          },
          goto_preious_end = {
            ['[A'] = { query = '@parameter.outer', desc = 'Prev parameter end' },
            ['[B'] = { query = '@block.outer', desc = 'Prev block end' },
            ['[C'] = { query = '@class.outer', desc = 'Prev class end' },
            ['[F'] = { query = '@function.outer', desc = 'Prev function end' },
            ['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
            ['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
            ['[M'] = { query = '@call.outer', desc = 'Prev call end' },
            ['[S'] = { query = '@statement.outer', desc = 'Prev statement end' },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>sa'] = { query = '@parameter.inner', desc = 'Swap param next' },
            ['<leader>sb'] = { query = '@block.outer', desc = 'Swap block next' },
            ['<leader>sc'] = { query = '@class.outer', desc = 'Swap class next' },
            ['<leader>sf'] = { query = '@function.outer', desc = 'Swap function next' },
            ['<leader>sm'] = { query = '@call.outer', desc = 'Swap call next' },
          },
          swap_previous = {
            ['<leader>sA'] = { query = '@parameter.inner', desc = 'Swap param prev' },
            ['<leader>sB'] = { query = '@block.outer', desc = 'Swap block prev' },
            ['<leader>sC'] = { query = '@class.outer', desc = 'Swap class prev' },
            ['<leader>sF'] = { query = '@function.outer', desc = 'Swap function prev' },
            ['<leader>sM'] = { query = '@call.outer', desc = 'Swap call prev' },
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
