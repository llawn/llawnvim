---@brief Bootstrap and configure lazy.nvim plugin manager.
---
--- This is based on the official installation instructions
--- from https://lazy.folke.io/installation.
---

-- Path where lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- If not already present, clone lazy.nvim from GitHub
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Prepend lazy.nvim to Neovim's runtime path
vim.opt.rtp:prepend(lazypath)


-- Now load and configure lazy.nvim
require("lazy").setup({
   -- My plugin spec
    spec = {
      { import = "llawn.plugins" },
      { import = "llawn.plugins.lsp" },
    },
    -- (Optional) automatically check for plugin updates
    checker = {
      enabled = true,
      notify = false,
    },
    -- (Optional) disable change detection notifications
    change_detection = {
      notify = false,
    }
})


