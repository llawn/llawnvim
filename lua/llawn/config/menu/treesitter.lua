--- Treesitter Manager

local M = {}
local lockfile_utils = require('llawn.utils.lockfile')
local menu_utils = require('llawn.utils.menu')

--- @class MyParserInfo
--- @field lang string The language name
--- @field name string The language name
--- @field description string The language description (README or ABOUT)
--- @field url string The remote url
--- @field target_rev string The up-to-date revision
--- @field installed_rev string The installed revision
--- @field is_installed boolean Is parser installed
--- @field needs_update boolean Is parser up-to-date

--- @param url string The parser name
--- @return string|nil content The README file or ABOUT section
--- @return boolean success If it success to find content
local function get_parser_remote_desc(url)
  local content = nil
  -- Branch to search
  local branches = { "main", "master" }
  -- Filename to search
  local files = { "README.md", "readme.md", "Readme.md", "README.rst", "README.txt", "README" }
  local success = false

  -----------------------------------------------------------------------------
  -- 1. GITHUB LOGIC (Using `gh`)
  -----------------------------------------------------------------------------
  if url:match("github.com") then
    local repo = url:gsub("https://github%.com/", ""):gsub("%.git$", "")
    local db_cmd = string.format(
      "gh repo view %s --json defaultBranchRef --jq .defaultBranchRef.name",
      vim.fn.shellescape(repo)
    )
    local db = vim.trim(vim.fn.system(db_cmd))
    local attempts = (vim.v.shell_error == 0 and db ~= "") and { db, "main", "master" } or branches

    for _, branch in ipairs(attempts) do
      if success then break end
      for _, file in ipairs(files) do
        local api_cmd = string.format(
          "gh api repos/%s/contents/%s?ref=%s -H 'Accept: application/vnd.github.raw'",
          repo,
          file,
          branch
        )
        local out = vim.fn.system(api_cmd)
        if vim.v.shell_error == 0 and out ~= "" and not out:match("^{") then
          content = out
          success = true
          break
        end
      end
    end
    -- Fallback to repo description if no README found
    if not success then
      local desc_cmd = "gh repo view " .. vim.fn.shellescape(repo) .. " --json description --jq .description"
      local desc = vim.trim(vim.fn.system(desc_cmd))
      if vim.v.shell_error == 0 and desc ~= "" then
        content = desc
        success = true
      end
    end
    -----------------------------------------------------------------------------
    -- 2. GITLAB LOGIC (Using `glab`)
    -----------------------------------------------------------------------------
  elseif url:match("gitlab.com") then
    local repo_path = url:gsub("https://gitlab%.com/", ""):gsub("%.git$", "")
    local encoded_repo = repo_path:gsub("/", "%%2F")
    local db_out = vim.fn.system("glab repo view " .. vim.fn.shellescape(repo_path) .. " --fields=default_branch")
    local db = db_out:match("default_branch:%s*(%S+)")
    local attempts = db and { db, "main", "master" } or branches

    for _, branch in ipairs(attempts) do
      if success then break end
      for _, file in ipairs(files) do
        local encoded_file = file:gsub("%.", "%%2E")
        local api_cmd = string.format(
          "glab api projects/%s/repository/files/%s/raw?ref=%s",
          encoded_repo,
          encoded_file,
          branch
        )
        local out = vim.fn.system(api_cmd)
        if vim.v.shell_error == 0 and out ~= "" then
          content = out
          success = true
          break
        end
      end
    end
    -----------------------------------------------------------------------------
    -- 3. CODEBERG / GENERIC LOGIC (Using `curl` + Nice URLs)
    -----------------------------------------------------------------------------
  else
    for _, branch in ipairs(branches) do
      if success then break end
      for _, file in ipairs(files) do
        local raw_url
        if url:match("codeberg.org") then
          raw_url = url:gsub("%.git$", "") .. "/raw/branch/" .. branch .. "/" .. file
        else
          raw_url = url:gsub("%.git$", "") .. "/raw/" .. branch .. "/" .. file
        end

        local cmd = "curl -s -L --max-time 8 " .. vim.fn.shellescape(raw_url)
        local out = vim.fn.system(cmd)
        if vim.v.shell_error == 0 and out ~= "" and not out:match("^<!DOCTYPE") then
          content = out
          success = true
          break
        end
      end
    end
  end
  return content, success
end

--- @param lang string The language name
--- @param config ParserInfo The parser info
--- @return string content The README file or ABOUT section
local function get_parser_desc(lang, config)
  local state_dir = vim.fn.stdpath("state") .. "/llawn/treesitter_readmes"
  vim.fn.mkdir(state_dir, "p")
  local readme_file = state_dir .. "/" .. lang .. ".txt"
  local content = nil
  local success = false
  if vim.fn.filereadable(readme_file) == 1 then
    content = table.concat(vim.fn.readfile(readme_file), "\n")
    success = true
  else
    local url = config.install_info.url
    content, success = get_parser_remote_desc(url)
    -- Cache handling
    if success and content ~= "" then
      vim.fn.writefile(vim.split(content, "\n"), readme_file)
    else
      content = "README unavailable"
      vim.fn.writefile({ content }, readme_file)
    end
  end
  return content
end

--- Gets parser information for a given language.
--- @param lang string The language name
--- @return MyParserInfo|nil Parser info table or nil if not found
local function get_parser_info(lang)
  local parsers = require('nvim-treesitter.parsers')
  local configs = require('nvim-treesitter.configs')
  local utils = require('nvim-treesitter.utils')
  local config = parsers.get_parser_configs()[lang]
  if not config then return nil end
  local lockfile = lockfile_utils.read_lockfile(utils.join_path(utils.get_package_path(), "lockfile.json"))
  local target_rev = config.install_info.revision or (lockfile[lang] and lockfile[lang].revision)
  local installed_rev = nil
  local info_dir = configs.get_parser_info_dir()

  if info_dir then
    local rev_file = utils.join_path(info_dir, lang .. ".revision")
    if vim.fn.filereadable(rev_file) == 1 then
      installed_rev = vim.fn.readfile(rev_file)[1]
    end
  end

  local is_installed = #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", true) > 0
  local description = get_parser_desc(lang, config)

  return {
    lang = lang,
    name = lang,
    description = description,
    url = config.install_info.url,
    target_rev = target_rev,
    installed_rev = installed_rev,
    is_installed = is_installed,
    needs_update = is_installed and target_rev ~= installed_rev
  }
end

--- Categorize parser info results
--- @param i MyParserInfo
--- @return InstallationStatus
local function categorize_results(i)
  if not i.is_installed then
    return menu_utils.Status.MISSING
  elseif i.needs_update then
    return menu_utils.Status.OUTDATED
  else
    return menu_utils.Status.UP_TO_DATE
  end
end

M.treesitter = {}

--- Displays the treesitter parser management menu.
--- @param filter string|nil The status filter to apply
M.treesitter.menu = function(filter)
  menu_utils.setup_highlights("TSInstallInfo")
  local items = {}
  local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
  local langs = vim.tbl_keys(parser_configs)
  table.sort(langs)

  for _, lang in ipairs(langs) do
    local info = get_parser_info(lang)
    if info then
      table.insert(items, info)
    end
  end

  local results = menu_utils.build_categorized_list(items, categorize_results, filter)

  local previewer = menu_utils.create_install_previewer(
    function(entry)
      local i = entry
      if type(i) == "string" then
        return { name = i, languages = "", url = "", target = "", status = "", description = "" }
      end
      return {
        name = i.lang,
        languages = "Parser",
        url = i.url or "N/A",
        target = (i.target_rev or "N/A"):sub(1, 7),
        status = categorize_results(i),
        description = i.description or "No description available"
      }
    end,
    "[F]ilter, [I]nstall, [X]Remove, [U]pdate, [O]pen in Browser, [L]oad description")

  local maker = menu_utils.gen_entry_maker(
    "lang",
    function(i) return (i.installed_rev or ""):sub(1, 7) end,
    categorize_results,
    "TSInstallInfo"
  )

  menu_utils.create_picker({
    prompt_title = "TS Manager",
    finder = require('telescope.finders').new_table({
      results = results,
      entry_maker = maker
    }),
    previewer = previewer,
    attach_mappings = menu_utils.create_attach_mappings(
      {
        I = {
          condition = function(i) return not i.is_installed end,
          action = function(i)
            pcall(function()
              vim.cmd("TSInstall " .. i.lang)
            end)
          end,
          msg = "Installing "
        },
        X = {
          condition = function(i) return i.is_installed end,
          action = function(i)
            pcall(function()
              vim.cmd("TSUninstall " .. i.lang)
            end)
          end,
          msg = "Uninstalling "
        },
        U = {
          condition = function(i) return i.needs_update end,
          action = function(i)
            pcall(function()
              vim.cmd("TSUpdate " .. i.lang)
            end)
          end,
          msg = "Updating "
        },
        O = {
          condition = function(i) return i.url ~= nil end,
          action = function(i) menu_utils.open_url(i.url) end
        },
        L = {
          condition = function(_) return true end,
          action = function(i)
            local state_dir = vim.fn.stdpath("state") .. "/llawn/treesitter_readmes"
            local readme_file = state_dir .. "/" .. i.lang .. ".txt"
            if vim.fn.delete(readme_file) == 0 then
              print("README cache cleared for " .. i.lang)
            else
              print("No cached README for " .. i.lang)
            end
          end,
          msg = "Clearing README cache for "
        }
      },
      function() M.treesitter.menu(filter) end, function(f)
        M.treesitter.menu(f)
      end)
  })
end

return M
