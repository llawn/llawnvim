--- Advanced Git Menu

local M = {}
M.git = {}

local Job = require("plenary.job")

local function get_commit_url(remote_url, hash)
  local base
  if remote_url:match("^git@") then
    base = remote_url:gsub("^git@", ""):gsub(":", "/"):gsub("%.git$", "")
  elseif remote_url:match("^https://") then
    base = remote_url:gsub("^https://", ""):gsub("%.git$", "")
  else
    return nil
  end
  if base:match("^github.com/") then
    return "https://" .. base .. "/commit/" .. hash
  elseif base:match("^gitlab.com/") then
    return "https://" .. base .. "/-/commit/" .. hash
  elseif base:match("^codeberg.org/") then
    return "https://" .. base .. "/commit/" .. hash
  end
  return nil
end

---------------------------------------------------------------------
-- MENU
---------------------------------------------------------------------

M.git.menu = function()
  local choices = {
    { "Log",  M.git.log },
    { "Diff", M.git.diff_menu },
  }

  vim.ui.select(
    choices,
    {
      prompt = "Git Menu:",
      format_item = function(item)
        return item[1]
      end,
    },
    function(choice)
      if choice then
        choice[2]()
      end
    end
  )
end

---------------------------------------------------------------------
-- COLORS / HIGHLIGHTS
---------------------------------------------------------------------

local colors = {
  hash     = "#ccccff",
  tag      = "#81d8d0",
  feat     = "#ace1af",
  fix      = "#fc89ac",
  chore    = "#91a3b0",
  docs     = "#89cff0",
  style    = "#e0b0ff",
  refactor = "#e0ab76",
  test     = "#fadfad",
  author   = "#73c2fb",
}

vim.api.nvim_set_hl(0, "GitHash", { fg = colors.hash })
vim.api.nvim_set_hl(0, "GitTag", { fg = colors.tag, italic = true })
vim.api.nvim_set_hl(0, "GitFeat", { fg = colors.feat, bold = true })
vim.api.nvim_set_hl(0, "GitFix", { fg = colors.fix, bold = true })
vim.api.nvim_set_hl(0, "GitChore", { fg = colors.chore })
vim.api.nvim_set_hl(0, "GitDocs", { fg = colors.docs })
vim.api.nvim_set_hl(0, "GitStyle", { fg = colors.style })
vim.api.nvim_set_hl(0, "GitRefactor", { fg = colors.refactor })
vim.api.nvim_set_hl(0, "GitTest", { fg = colors.test })
vim.api.nvim_set_hl(0, "GitAuthor", { fg = colors.author })

---------------------------------------------------------------------
-- STRUCTURED QUERY PARSER
---------------------------------------------------------------------

local function parse_query(prompt)
  local filters = {}
  local fuzzy = {}

  for word in prompt:gmatch("%S+") do
    local k, v = word:match("^(%w+):(.+)$")
    if k and v then
      filters[k] = filters[k] or {}
      table.insert(filters[k], v:lower())
    else
      table.insert(fuzzy, word)
    end
  end

  return filters, table.concat(fuzzy, " ")
end

local function matches(entry, filters)
  for key, values in pairs(filters) do
    local field =
        (key == "author" and entry.author)
        or (key == "msg" and entry.msg)
        or (key == "hash" and entry.hash)
        or (key == "type" and entry.type)

    if not field then return false end

    field = field:lower()

    local ok = false
    for _, v in ipairs(values) do
      if field:find(v, 1, true) then
        ok = true
        break
      end
    end
    if not ok then return false end
  end
  return true
end

---------------------------------------------------------------------
-- GIT LOG
---------------------------------------------------------------------
M.git.log = function(opts)
  opts                = opts or {}
  local pickers       = require("telescope.pickers")
  local finders       = require("telescope.finders")
  local sorters       = require("telescope.sorters")
  local previewers    = require("telescope.previewers")
  local entry_display = require("telescope.pickers.entry_display")
  local putils        = require("telescope.previewers.utils")
  local actions       = require("telescope.actions")
  local action_state  = require("telescope.actions.state")

  -------------------------------------------------------------------
  -- DISPLAY
  -------------------------------------------------------------------

  local displayer     = entry_display.create({
    separator = " ",
    items = {
      { width = 3 },  -- graph
      { width = 8 },  -- hash
      { width = 12 }, -- tags
      { remaining = true },
      { width = 14,      align = "right" },
    },
  })

  -------------------------------------------------------------------
  -- DATA STORE (incremental)
  -------------------------------------------------------------------

  local commits       = {}

  -------------------------------------------------------------------
  -- DYNAMIC FINDER
  -------------------------------------------------------------------
  local finder        = finders.new_dynamic({
    fn = function(prompt)
      local filters = parse_query(prompt)
      local results = {}
      for _, c in ipairs(commits) do
        if matches(c, filters) then
          table.insert(results, c)
        end
      end
      return results
    end,

    entry_maker = function(c)
      local type_hl = ({
        feat = "GitFeat",
        fix = "GitFix",
        chore = "GitChore",
        docs = "GitDocs",
        style = "GitStyle",
        refactor = "GitRefactor",
        test = "GitTest",
      })[c.type] or "Comment"

      return {
        value = c,

        -- fuzzy relevance + date tie-break
        ordinal =
            c.author .. " " ..
            c.msg .. " " ..
            c.hash .. " " ..
            c.tags .. " " ..
            c.type .. " " ..
            string.format("%020d", 2 ^ 60 - c.date),

        display = function()
          return displayer({
            { c.graph, "Comment" },
            { c.hash, "GitHash" },
            { c.tags ~= "" and " " .. c.tags or "", "GitTag" },
            { c.msg, type_hl },
            { "<" .. c.author .. ">", "GitAuthor" },
          })
        end,
      }
    end,
  })

  -------------------------------------------------------------------
  -- PICKER
  -------------------------------------------------------------------
  pickers.new({}, {
    prompt_title = "Git Log",
    default_text = opts.default_text or "",

    finder = finder,

    sorter = sorters.get_fzf_sorter and sorters.get_fzf_sorter() or sorters.get_generic_fuzzy_sorter(),

    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry)
        putils.job_maker({
          "git", "show", "--stat", "-p",
          "--date=format:%Y %b %d %H:%M:%S %z",
          entry.value.hash,
        }, self.state.bufnr, {
          callback = function(bufnr)
            vim.bo[bufnr].filetype = "diff"
          end,
        })
      end,
    }),

    attach_mappings = function(prompt_bufnr, map)
      map({ "i", "n" }, "<CR>", function()
        local sel = action_state.get_selected_entry()
        if not sel then return end
        local search = (vim.api.nvim_buf_get_lines(prompt_bufnr, 0, -1, false)[1] or ""):gsub("^> ?", "")
        actions.close(prompt_bufnr)
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].filetype = "diff"
        local h = io.popen("git show " .. sel.value.hash)
        if not h then return end
        local result = h:read("*a")
        h:close()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.8),
          col = math.floor(vim.o.columns * 0.1),
          row = math.floor(vim.o.lines * 0.1),
          style = "minimal",
          border = "rounded",
        })
        local escaped_search = search:gsub("'", "\\'"):gsub('"', '\\"')
        vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>",
          string.format(
            "<cmd>lua vim.api.nvim_win_close(%d, true); require('llawn.config.menu.git').git.log({default_text='%s'})<CR>",
            win, escaped_search), { noremap = true })
      end)
      map({ "i", "n" }, "<C-o>", function()
        local sel = action_state.get_selected_entry()
        if not sel then return end
        local remote = vim.fn.system("git config --get remote.origin.url"):gsub("\n$", "")
        if not remote or remote == "" then
          vim.api.nvim_echo({ { "No remote origin found", "WarningMsg" } }, false, {})
          return
        end
        vim.api.nvim_echo({ { "Remote: " .. remote, "Normal" } }, false, {})
        local url = get_commit_url(remote, sel.value.hash)
        if url then
          vim.api.nvim_echo({ { "Opening: " .. url, "Normal" } }, false, {})
          vim.fn.jobstart({ "flatpak", "run", "app.zen_browser.zen", url }, { detach = true })
        else
          vim.api.nvim_echo({ { "Unsupported remote: " .. remote, "WarningMsg" } }, false, {})
        end
      end)
      return true
    end,
  }):find()

  -------------------------------------------------------------------
  -- ASYNC GIT JOB
  -------------------------------------------------------------------
  Job:new({
    command = "git",
    args = {
      "log",
      "--graph",
      "--pretty=format:%x1f%h%x1f%d%x1f%an%x1f%ad%x1f%s",
      "--date=format:%s",
      "--all",
    },

    on_stdout = function(_, line)
      local graph, hash, tags, author, date, msg =
          line:match("^(.-)\31(.-)\31(.-)\31(.-)\31(.-)\31(.+)$")
      if not hash then return end

      local type_full = msg:match("^([%w_]+%([^)]+%))?:") or msg:match("^([%w_]+):") or ""
      local type = type_full:match("^([%w_]+)") or ""

      table.insert(commits, {
        graph  = graph,
        hash   = hash,
        tags   = tags:gsub("[() ]", ""),
        author = author,
        date   = tonumber(date),
        msg    = msg,
        type   = type:lower(),
      })
    end,
  }):start()
end

---------------------------------------------------------------------
-- GIT DIFF MENU
---------------------------------------------------------------------

M.git.diff_menu = function()
  local choices = {
    { "Unstaged Diff", "unstaged" },
    { "Staged Diff",   "staged" },
  }

  vim.ui.select(choices, {
    prompt = "Diff Type:",
    format_item = function(item)
      return item[1]
    end,
  }, function(choice)
    if choice then
      M.git.show_diff(choice[2])
    end
  end)
end

M.git.show_diff = function(type)
  local cached = type == "staged" and "--cached" or ""
  local cmd = "git diff --name-status " .. cached
  local diff_handle = io.popen(cmd)
  if not diff_handle then return end

  local result = diff_handle:read("*a")
  diff_handle:close()

  local lines = vim.split(result, "\n", { trimempty = true })

  if #lines == 0 then
    print("No " .. type .. " changes")
    return
  end

  local files = {}
  for _, line in ipairs(lines) do
    local status, file = line:match("^(%w)%s+(.+)")
    if status and file then
      table.insert(files, { status = status, file = file })
    end
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local sorters = require("telescope.sorters")
  local previewers = require("telescope.previewers")

  local diff_previewer = previewers.new_buffer_previewer({
    title = "Diff",
    define_preview = function(self, entry, _)
      local bufnr = self.state.bufnr
      local file_diff_handle = io.popen(
        "git diff "
        .. cached
        .. " -- "
        .. vim.fn.shellescape(entry.value.file)
      )
      if not file_diff_handle then return end

      local content = file_diff_handle:read("*a")
      file_diff_handle:close()

      local diff_lines = vim.split(content, "\n")
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, diff_lines)

      -- Highlight diff
      local ns_id = vim.api.nvim_create_namespace("git_diff")
      for i, line in ipairs(diff_lines) do
        if vim.startswith(line, "+") then
          vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, {
            end_col = #line,
            hl_group = "DiffAdd",
          })
        elseif vim.startswith(line, "-") then
          vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, {
            end_col = #line,
            hl_group = "DiffDelete",
          })
        elseif vim.startswith(line, "@@") then
          vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, {
            end_col = #line,
            hl_group = "DiffChange",
          })
        end
      end
    end,
  })

  local entry_maker = function(entry)
    return {
      value = entry,
      display = function(e)
        local status = e.value.status
        local file = e.value.file

        local hl_group = ""
        if status == "M" then
          hl_group = "DiffChange"
        elseif status == "A" then
          hl_group = "DiffAdd"
        elseif status == "D" then
          hl_group = "DiffDelete"
        elseif status == "R" then
          hl_group = "DiffText"
        end

        return string.format("[%s] %s", status, file), {
          { { 0, 3 }, hl_group },
        }
      end,
      ordinal = entry.file,
    }
  end

  pickers.new({}, {
    prompt_title = type .. " Diff",
    finder = finders.new_table({
      results = files,
      entry_maker = entry_maker,
    }),
    sorter = sorters.get_fzf_sorter and sorters.get_fzf_sorter() or sorters.get_generic_fuzzy_sorter(),
    previewer = diff_previewer,
  }):find()
end

return M
