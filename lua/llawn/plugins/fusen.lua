return {
  "walkersumida/fusen.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = "VimEnter",
  keys = {
    { "<leader>nt", "<cmd>FusenToggle<cr>" },
    { "<leader>nf", "<cmd>Telescope fusen marks<cr>" },
    { "<leader>ni", "<cmd>FusenInfo<cr>" },
  },
  opts = {
    save_file = vim.fn.stdpath("data") .. "/fusen_marks.json",
    annotation_display = {
      mode = "float",
      hover = {
        delay = 300,
        border = "rounded",
        max_width = 60,
        max_height = 15,
        focusable = true,
      }
    },
    keymaps = {
      add_mark = "ne",
      clear_mark = "nc",
      clear_buffer = "nC",
      clear_all = "nD",
      next_mark = "]n",
      prev_mark = "[n",
      list_marks = "nl",
    },
  }
}
