return {
  cmd = { 'pyright', '--stdio' },
  filetypes = { 'python' },
  single_file_support = true,
  root_markers = {
    'pyproject.toml',
    'pyrightconfig.json',
    '.git',
  },
  on_attach = function(client)
    -- Disable capabilities that Ruff will handle.
    -- This prevents duplicate diagnostics, formatting issues, and conflicting code actions.
    client.server_capabilities.diagnosticProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.codeActionProvider = false
  end,
}
