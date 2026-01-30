-- Plugin: nvim-dap
-- Description: Debug Adapter Protocol client implementation for Neovim
-- Automatically handles UI, Virtual Text, and Mason integration.

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
      "williamboman/mason.nvim",
      "llawn/save-my-breakpoints.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local smb = require('save-my-breakpoints')

      --- Mason DAP Setup ---
      require("mason-nvim-dap").setup({
        automatic_installation = false,
        ensure_installed = {},
        handlers = {
          function(config)
            require('mason-nvim-dap').default_setup(config)
          end,
        },
      })

      --- UI & Virtual Text Initialization ---
      dapui.setup()
      require("nvim-dap-virtual-text").setup({
        commented = true, -- Show virtual text as a comment
      })

      local signs = {
        DapBreakpoint          = { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" },
        DapBreakpointCondition = { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" },
        DapLogPoint            = { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" },
        DapStopped             = { text = "󰁕", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" },
        DapBreakpointRejected  = { text = "󰅙", texthl = "DapBreakpointRejected", linehl = "", numhl = "" },
      }

      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#ff0800', bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#da9100', bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#6cb4ee', bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#93c572', bg = '#353839', bold = true })
      vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#536878', bg = 'NONE' })

      for name, sign in pairs(signs) do
        vim.fn.sign_define(name, sign)
      end

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      --- Keymaps ---
      local set = vim.keymap.set
      set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      set("n", "<F6>", dap.step_over, { desc = "Debug: Step Over" })
      set("n", "<F7>", dap.step_into, { desc = "Debug: Step Into" })
      set("n", "<F8>", dap.step_out, { desc = "Debug: Step Out" })
      set("n", "<F9>", dap.run_last, { desc = "Run Last" })
      set("n", "<Leader>Dc", smb.set_conditional_breakpoint, { desc = "Conditional Breakpoint" })
      set("n", "<Leader>Dd", smb.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      set("n", "<Leader>De", function()
        require("dapui").eval()
      end, { desc = "Evaluate under cursor" })
      set("n", "<Leader>Dl", smb.set_log_point, { desc = "Log Point" })
      set("n", "<Leader>Dr", dap.repl.open, { desc = "Open REPL" })
      set("n", "<Leader>Du", dapui.toggle, { desc = "Toggle UI" })
      set("n", "<Leader>Dx", smb.clear_all_breakpoints, { desc = "Clear All Breakpoints" })

      --- Save My Breakpoints Setup ---
      require('save-my-breakpoints').setup({
        save_dir = vim.fn.stdpath('data') .. '/breakpoints',
        load_on_buffer_open = true,
        save_on_exit = true,
        telescope_menu = true,
      })

      --- Load Custom Language Configs ---
      -- Dynamically loads files from lua/llawn/config/dap/*.lua
      local dap_config_path = vim.fn.stdpath("config") .. "/lua/llawn/config/dap/"
      local files = vim.fn.glob(dap_config_path .. "*.lua", false, true)

      for _, file in ipairs(files) do
        local module_name = file:match("([^/]+)%.lua$")
        if module_name then
          require("llawn.config.dap." .. module_name)
        end
      end
    end,
  },
}
