-- Plugin: Lualine
-- Description: Configures Lualine statusline with custom LSP and Treesitter status indicators

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    -- Define highlight groups for icons
    vim.cmd('hi LspIcon guifg=#dbd7d2')
    vim.cmd('hi TsIcon guifg=#00ff7f')
    vim.cmd('hi NoIcon guifg=#ff0000')
    vim.cmd('hi Text guifg=#e6e6fa')

    -- Custom function to display active LSP client names for the current buffer
    local function lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local text = "%#LspIcon#󰛓%* "
      if #clients == 0 then
        text = text .. "%#NoIcon#%*"
      else
        local names = {}
        for _, client in ipairs(clients) do
          table.insert(names, client.name)
        end
        text = text .. "%#Text#" .. table.concat(names, ", ") .. "%*"
      end
      return text
    end

    -- Custom function to display TS parsers for the current buffer
    local function treesitter_status()
      local buf = vim.api.nvim_get_current_buf()
      local parser = vim.treesitter.get_parser(buf)
      local text = "%#TsIcon#%* "
      if not parser then
        text = text .. "%#NoIcon#%*"
      else
        text = text .. "%#Text#" .. parser:lang() .. "%*"
      end
      return text
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = true,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        }
      },
      -- Define the statusline sections with various components
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {
          lsp_status,
          treesitter_status,
          'filetype',
          'encoding',
          'fileformat'
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
  end
}
