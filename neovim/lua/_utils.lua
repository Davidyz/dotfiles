local os = require("os")
local co = require("coroutine")

local M = {}

HOME = os.getenv("HOME")

SOURCE_CODE = {
  "java",
  "c",
  "cpp",
  "python",
  "hs",
  "sh",
  "go",
  "php",
  "json",
  "bash",
  "zsh",
  "vim",
  "lua",
  "make",
}
TEXT = { "md", "txt", "markdown", "rmd", "pandoc", "text", "tex" }

M.gitModified = function()
  local files = nil
  if vim.fn.has("unix") then
    files = vim.fn.systemlist("git ls-files -m 2> /dev/null")
  else
    files = vim.fn.systemlist("git ls-files -m")
  end
  if files then
    return vim.fn.map(files, "{'line': v:val, 'path': v:val}")
  end
end

M.gitUntracked = function()
  local files = nil
  if vim.fn.has("unix") then
    files = vim.fn.systemlist("git ls-files -o --exclude-standard 2> /dev/null")
  else
    files = vim.fn.systemlist("git ls-files -o --exclude-standard")
  end
  if files then
    return vim.fn.map(files, "{'line': v:val, 'path': v:val}")
  end
end

---@param array table
---@return boolean
function M.contains(array, element)
  for _, value in pairs(array) do
    if value == element then
      return true
    end
  end
  return false
end

---@param filetype
---@return boolean
function M.isSourceCode(filetype)
  return M.contains(SOURCE_CODE, filetype)
end

---@return string
function M.getHostname()
  if vim.fn.hostname ~= nil then
    return vim.fn.hostname()
  end
  return ""
end

---@return string
function M.getUserName()
  local username = vim.fn.getenv("USER")
  if username == nil then
    username = vim.fn.getenv("USERNAME")
  end
  return username
end

function M.get_ColorCode(group, tag)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), tag)
end

---@param str string
function M.getTermCode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.sendKey(str, mode, escape)
  if escape == nil then
    escape = false
  end
  return vim.api.nvim_feedkeys(str, mode, escape)
end

---@param item string
function M.Require(item)
  if not type(item) == "string" then
    return false
  end
  local status, error_message = pcall(require, item)
  if not status then
    print(error_message)
  end
  return status
end

local stat_height = vim.o.cmdheight

---@param items string[]
---@param retry_count integer
function M.tryRequire(items, retry_count)
  if retry_count == 0 then
    stat_height = vim.o.cmdheight
    vim.o.cmdheight = #items + 1
    vim.api.nvim_echo(
      { { "Failed to require the following files:", "None" } },
      false,
      {}
    )
    for _, item in ipairs(items) do
      vim.api.nvim_echo({ { item, "None" } }, false, {})
    end
    return
  end
  retry_count = retry_count or 10
  local failed = {}
  for _, item in ipairs(items) do
    local status = M.Require(item)
    if not status then
      table.insert(failed, item)
    end
  end
  if #failed > 0 then
    M.tryRequire(failed, retry_count - 1)
  end
end

---@param array table
---@param func function
---@return boolean
function M.any(array, func)
  if type(func) ~= "function" then
    func = function(item)
      return item
    end
  end
  for i, item in ipairs(array) do
    if func(item) then
      return true
    end
  end
  return false
end

---@param array table
---@param func function
---@return boolean
function M.all(array, func)
  if type(func) ~= "function" then
    func = function(item)
      return item
    end
  end
  for i, item in ipairs(array) do
    if not func(item) then
      return false
    end
  end
  return true
end

--- separate a string.
---@param inputstr string
---@param sep string
---@return table
function M.split(inputstr, sep)
  sep = sep or "%s"
  local t = {}
  for field, s in string.gmatch(inputstr, "([^" .. sep .. "]*)(" .. sep .. "?)") do
    table.insert(t, field)
    if s == "" then
      return t
    end
  end
end

---@param func function
---@param callback function
M.async_run = function(func, callback)
  assert(type(func) == "function", "type error :: expected func")
  local thread = co.create(func)
  local step = nil
  step = function(...)
    local stat, ret = co.resume(thread, ...)
    assert(stat, ret)
    if co.status(thread) == "dead" then
      (callback or function(arg) end)(ret)
    else
      assert(type(ret) == "function", "type error :: expected func")
      ret(step)
    end
  end
  step()
end

---@return integer
M.cpu_count = function()
  if vim.uv == nil or vim.uv.cpu_info == nil then
    return #vim.loop.cpu_info()
  end
  return #vim.uv.cpu_info()
end

---@return integer
M.line_length = function()
  if vim.bo.textwidth == 0 then
    return nil
  else
    return vim.bo.textwidth
  end
end

---@return boolean
M.no_vscode = function()
  return vim.g.vscode == nil
end

---@return boolean
M.is_treesitter_enabled = function()
  local okay, parsers = pcall(require, "nvim-treesitter.parsers")
  if not okay then
    return false
  end
  local lang = parsers.get_buf_lang()
  return parsers.has_parser(lang)
end

---@return Range4
M.has_selection = function()
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\22' then -- Normal, Line, or Block visual mode
    local mark_start = vim.api.nvim_buf_get_mark(0, '<')
    local mark_end = vim.api.nvim_buf_get_mark(0, '>')

    if mark_start[1] ~= mark_end[1] or mark_start[2] ~= mark_end[2] then
      return {
        mark_start[1],
        mark_start[2],
        mark_end[1],
        mark_end[2]
      }
    end
  end
  return nil
end

return M
