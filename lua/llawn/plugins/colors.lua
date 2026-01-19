-- Plugin: Rose-Pine Color Scheme
-- Description: Configures the Rose-Pine color scheme with a transparent background,
--              custom highlights for invisible characters, and optional hex color highlighter.
-- Based on: https://github.com/ThePrimeagen/init.lua

local colors = {
  nontext = "#9eb9d4",
  whitespace = "#ed7a9b",
  specialkey = "#e9d66b",
  endofbuffer = "#708090",
}

--- Function to set up a color scheme with custom highlights
--- @param color string|nil
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

      -- Setup color highlighter if available
      local ok, highlighter = pcall(require, 'llawn.colors.colors_highlighter')
      if ok then
        highlighter.setup()
      else
        vim.notify('Custom color highlighter not found, skipping setup.', vim.log.levels.WARN)
      end
    end
  },

}
