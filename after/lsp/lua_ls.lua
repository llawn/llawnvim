---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          "${3rd}/luv/library",
          vim.env.VIMRUNTIME .. "/lua",
        },
      },
      telemetry = { enable = false },
    },
  },
}