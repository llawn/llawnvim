local dap = require("dap")

--- Helper function to find the python executable in a local venv
local function get_python_path()
  local cwd = vim.fn.getcwd()
  local venv_names = { ".venv", "venv" }

  for _, name in ipairs(venv_names) do
    local path = cwd .. "/" .. name .. "/bin/python"
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  -- Fallback to system python or active shell python
  return "python"
end

-- 1. Adapter Configuration
-- This tells DAP how to run the debugpy engine itself.
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    local port = (config.connect or config).port
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = { source_filetype = 'python' },
    })
  else
    -- Point to the debugpy installed via Mason
    local debugpy_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
    cb({
      type = 'executable',
      command = debugpy_path,
      args = { '-m', 'debugpy.adapter' },
      options = { source_filetype = 'python' },
    })
  end
end

-- 2. Debug Configurations
-- These are the options that appear when you start debugging.
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file (Auto-detect Venv)",
    program = "${file}",
    pythonPath = get_python_path(),
    cwd = vim.fn.getcwd(), -- Runs from the project root
  },
  {
    type = "python",
    request = "launch",
    name = "Launch file with arguments",
    program = "${file}",
    pythonPath = get_python_path(),
    cwd = vim.fn.getcwd(),
    args = function()
      local args_string = vim.fn.input("Arguments: ")
      return vim.split(args_string, " ")
    end,
  },
  {
    type = "python",
    request = "attach",
    name = "Attach to remote debugger",
    host = function()
      local value = vim.fn.input("Host (127.0.0.1): ")
      if value == "" then return "127.0.0.1" end
      return value
    end,
    port = function()
      return tonumber(vim.fn.input("Port: "))
    end,
  },
}
