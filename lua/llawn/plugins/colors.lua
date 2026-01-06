--- @brief This file configures the Rose-Pine color scheme
--- Based on: https://github.com/ThePrimeagen/init.lua
---

local colors = {
  nontext = "#9ccfd8",
  whitespace = "#eb6f92",
  specialkey = "#f6c177",
  endofbuffer = "#6e6a86"
}

-- Function to set up a color scheme with custom highlights
function ColorMyPencils(color)
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
    end
  },

}

