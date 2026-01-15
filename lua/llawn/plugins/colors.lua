--- @brief This file configures the Rose-Pine color scheme
--- Based on: https://github.com/ThePrimeagen/init.lua
---

local colors = {
  nontext = "#9eb9d4",
  whitespace = "#ed7a9b",
  specialkey = "#e9d66b",
  endofbuffer = "#708090",
}

-- Function to set up a color scheme with custom highlights
function ColorMyPencils(color)
  -- Default to "rose-pine-moon"
  color = color or "rose-pine-moon"

  -- Transparent background
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  -- Customize visibility of normally invisible characters
  vim.api.nvim_set_hl(0, "NonText", { fg = colors.nontext, bold = true })
  vim.api.nvim_set_hl(0, "Whitespace", { fg = colors.whitespace, italic = true })
  vim.api.nvim_set_hl(0, "SpecialKey", { fg = colors.specialkey, bold = true })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = colors.endofbuffer })

end

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require('rose-pine').setup({
        variant = "moon",
        disable_background = true,
        styles = {
          italic = false,
        },
      })

       -- Apply the custom colors and highlights
       ColorMyPencils();

       -- Setup color highlighter
       local highlighter = require('llawn.plugins.local.colors_highlighter')
       highlighter.setup()
      end
    },

}

