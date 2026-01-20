-- Plugin: Render Markdown
-- Description: render-markdown provides enhanced markdown rendering in Neovim

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = 'markdown',
  keys = {
    { '<leader>pm', '<cmd>RenderMarkdown toggle<cr>', desc = 'Toggle MD Render' },
  },
  config = function()
    require('render-markdown').setup({
      enabled = true,
      checkbox = {
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰄵 ' },
      },
    })
  end
}
