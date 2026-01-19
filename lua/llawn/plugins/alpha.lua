-- Plugin: Alpha Dashboard
-- Description: Configures the alpha-nvim plugin to display a custom dashboard
--              with ASCII art header and navigation buttons.

return {
  "goolord/alpha-nvim",

  -- Configures the alpha dashboard theme and sections
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "                                                                      ",
      "  ██╗     ██╗      █████╗ ██╗    ██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗ ",
      "  ██║     ██║     ██╔══██╗██║    ██║████╗  ██║██║   ██║██║████╗ ████║ ",
      "  ██║     ██║     ███████║██║ █╗ ██║██╔██╗ ██║██║   ██║██║██╔████╔██║ ",
      "  ██║     ██║     ██╔══██║██║███╗██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ███████╗███████╗██║  ██║╚███╔███╔╝██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚══════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                                      ",
    }

    dashboard.section.buttons.val = {
      dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("s", "  Settings", ":e ~/.config/nvim<CR>"),
      dashboard.button("q", "󰈆  Quit", ":qa<CR>"),
    }

    alpha.setup(dashboard.opts)
  end,
}
