-- Open netrw on the current file's directory and place the cursor on that file.
-- This keeps the built-in netrw explorer; no external plugin is involved.

local M = {}

local function open_netrw(dir)
  vim.fn["netrw#Explore"](0, 0, 0, dir)
end

local function find_file_line(buf, filename)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  for i, line in ipairs(lines) do
    if not line:match("^%s*\"") then
      local name = line:match("^[| ]*(.-)/?%s*$")
      if name == filename then
        return i
      end
    end
  end
end

local function reveal(filename)
  if not filename or filename == "" then
    return
  end

  vim.defer_fn(function()
    if vim.bo.filetype ~= "netrw" then
      return
    end

    local line = find_file_line(0, filename)
    if line then
      vim.api.nvim_win_set_cursor(0, { line, 0 })
      vim.cmd("normal! zz")
    end
  end, 30)
end

function M.open_current_file_dir()
  local current = vim.api.nvim_buf_get_name(0)

  if current == "" or vim.fn.isdirectory(current) == 1 then
    open_netrw(vim.fn.getcwd())
    return
  end

  local dir = vim.fn.fnamemodify(current, ":p:h")
  local filename = vim.fn.fnamemodify(current, ":t")

  open_netrw(dir)
  reveal(filename)
end

function M.setup()
  vim.keymap.set("n", "<F13>t", M.open_current_file_dir, { desc = "Open explorer on current file" })
end

M.setup()

return M
