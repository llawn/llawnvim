return {
  "dimtion/guttermarks.nvim",
  event = "VeryLazy",
  opts = {
    global_mark = { enabled = true },
    special_mark = { enabled = false },
  },
  keys = {
    {
      "]m",
      function()
        require("guttermarks.actions").next_buf_mark()
      end,
      desc = "Next Mark",
    },
    {
      "[m",
      function()
        require("guttermarks.actions").prev_buf_mark()
      end,
      desc = "Prev Mark",
    },
    {
      "m;",
      function()
        require("guttermarks.actions").delete_mark()
      end,
      desc = "Delete mark on current line",
    },
  },
}
