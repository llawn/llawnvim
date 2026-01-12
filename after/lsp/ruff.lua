---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  -- The on_attach function must be inside this same table
  on_attach = function(client, _)
    -- Prevent Ruff from competing with 'ty' for hover documentation
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,

  settings = {
    -- You can add specific ruff settings here, like:
    -- args = { "--ignore", "E501" }
  },
}
