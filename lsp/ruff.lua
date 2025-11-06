return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },

  root_markers = {
    'pyproject.toml',
    'ruff.toml',
    '.git',
  },

  settings = {
    lint = {
      select = { 'E', 'F', 'B', 'I' },
      ignore = { 'E501' },
    },
    format = {
      line_length = 80,
    },
  },
}
