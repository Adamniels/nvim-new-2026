-- netrw_git.lua
-- Shows git status labels as virtual text in netrw buffers.
-- Status propagates up to parent directories.
-- No plugins required.

local M = {}

local ns = vim.api.nvim_create_namespace("netrw_git")

-- Higher number = shown over lower priority status on parent dirs
local sym_priority = {
  ["!"] = 6,
  ["D"] = 5,
  ["S"] = 4,
  ["M"] = 4,
  ["A"] = 3,
  ["?"] = 2,
  ["i"] = 1,
}

local status_symbols = {
  ["M "] = { sym = "S",  hl = "NetrwGitStaged" },     -- staged modification
  [" M"] = { sym = "M",  hl = "NetrwGitModified" },   -- unstaged modification
  ["MM"] = { sym = "M",  hl = "NetrwGitModified" },   -- staged + unstaged
  ["A "] = { sym = "A",  hl = "NetrwGitAdded" },      -- new file staged
  ["AM"] = { sym = "A",  hl = "NetrwGitAdded" },      -- added then modified
  ["??"] = { sym = "?",  hl = "NetrwGitUntracked" },  -- untracked
  ["D "] = { sym = "D",  hl = "NetrwGitDeleted" },    -- deleted staged
  [" D"] = { sym = "D",  hl = "NetrwGitDeleted" },    -- deleted unstaged
  ["R "] = { sym = "R",  hl = "NetrwGitRenamed" },    -- renamed staged
  ["UU"] = { sym = "!",  hl = "NetrwGitConflict" },   -- merge conflict
  ["!!"] = { sym = "i",  hl = "NetrwGitIgnored" },    -- ignored
}

local function setup_highlights()
  vim.api.nvim_set_hl(0, "NetrwGitStaged",    { fg = "#98c379" })             -- green
  vim.api.nvim_set_hl(0, "NetrwGitModified",  { fg = "#e5c07b" })             -- yellow
  vim.api.nvim_set_hl(0, "NetrwGitAdded",     { fg = "#98c379" })             -- green
  vim.api.nvim_set_hl(0, "NetrwGitUntracked", { fg = "#61afef" })             -- blue
  vim.api.nvim_set_hl(0, "NetrwGitDeleted",   { fg = "#e06c75" })             -- red
  vim.api.nvim_set_hl(0, "NetrwGitRenamed",   { fg = "#c678dd" })             -- purple
  vim.api.nvim_set_hl(0, "NetrwGitConflict",  { fg = "#e06c75", bold = true })-- red bold
  vim.api.nvim_set_hl(0, "NetrwGitIgnored",   { fg = "#5c6370" })             -- gray
end

local function fetch_git_status(dir, cb)
  local result = {}

  vim.fn.jobstart(
    { "git", "-C", dir, "status", "--porcelain", "--untracked-files=all" },
    {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        for _, line in ipairs(data) do
          if #line >= 4 then
            local code = line:sub(1, 2)
            local file = line:sub(4)
            -- Handle renames: "old -> new"
            file = file:match("^.* %-> (.+)$") or file
            -- Strip trailing whitespace
            file = file:match("^(.-)%s*$")

            local info = status_symbols[code]
            if info then
              local new_pri = sym_priority[info.sym] or 0

              -- Store the file's own basename
              local basename = vim.fn.fnamemodify(file, ":t")
              if new_pri > (sym_priority[(result[basename] or {}).sym] or 0) then
                result[basename] = info
              end

              -- Bubble up: register every parent directory segment
              local parts = {}
              for part in file:gmatch("[^/]+") do
                table.insert(parts, part)
              end
              for j = 1, #parts - 1 do
                local dir_name = parts[j]
                if new_pri > (sym_priority[(result[dir_name] or {}).sym] or 0) then
                  result[dir_name] = info
                end
              end
            end
          end
        end
      end,
      on_stderr = function(_, _) end,
      on_exit = function(_, code)
        -- 0 = clean/changes, 128 = not a git repo (silently skip)
        if code == 0 or code == 1 then
          cb(result)
        end
      end,
    }
  )
end

local function decorate_buffer(buf, git_map)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  for i, line in ipairs(lines) do
    -- Skip netrw header/comment lines (start with optional whitespace then ")
    if not line:match("^%s*\"") and #line > 0 then
      -- Strip leading tree decoration (| | | ...) to get the bare name
      local name = line:match("^[| ]*(.+)$")
      if name then
        -- Strip trailing slash (directories) and whitespace
        local lookup = name:match("^(.-)/?%s*$")
        local info = git_map[lookup]
        if info then
          vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
            virt_text = { { " " .. info.sym, info.hl } },
            virt_text_pos = "eol",
          })
        end
      end
    end
  end
end

local function on_netrw_enter(buf)
  local dir = vim.fn.expand("%:p")
  if vim.fn.isdirectory(dir) == 0 then
    dir = vim.b[buf].netrw_curdir or vim.fn.getcwd()
  end

  fetch_git_status(dir, function(git_map)
    vim.schedule(function()
      decorate_buffer(buf, git_map)
    end)
  end)
end

function M.setup()
  setup_highlights()

  -- Reapply after colorscheme switches so our explicit colors persist
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = setup_highlights,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      on_netrw_enter(buf)

      vim.api.nvim_create_autocmd("BufEnter", {
        buffer = buf,
        callback = function()
          on_netrw_enter(buf)
        end,
      })
    end,
  })
end

M.setup()

return M
