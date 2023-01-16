local os = require("os")
local co = require("coroutine")

local M = {}

HOME = os.getenv("HOME")

SOURCE_CODE = { "java", "c", "cpp", "python", "hs", "sh", "go", "php", "json", "bash", "zsh", "vim", "lua", "make" }
TEXT = { "md", "txt", "markdown", "rmd", "pandoc", "text", "tex" }

M.gitModified = function()
  if vim.fn.has("unix") then
    local files = vim.fn.systemlist("git ls-files -m 2> /dev/null")
    if files then
      return vim.fn.map(files, "{'line': v:val, 'path': v:val}")
    end
  end
end

M.gitUntracked = function()
  if vim.fn.has("unix") then
    local files = vim.fn.systemlist("git ls-files -o --exclude-standard 2> /dev/null")
    if files then
      return vim.fn.map(files, "{'line': v:val, 'path': v:val}")
    end
  end
end

function M.contains(array, element)
  for _, value in pairs(array) do
    if value == element then
      return true
    end
  end
  return false
end

function M.isSourceCode(filetype)
  return M.contains(SOURCE_CODE, filetype)
end

function M.getHostname()
  if vim.fn.hostname ~= nil then
    return vim.fn.hostname()
  end
  return ""
end

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

function M.getTermCode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.sendKey(str, mode, escape)
  if escape == nil then
    escape = false
  end
  return vim.api.nvim_feedkeys(string, mode, escape)
end

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

function M.tryRequire(items, retry_count)
  if retry_count == 0 then
    stat_height = vim.o.cmdheight
    vim.o.cmdheight = #items + 1
    vim.api.nvim_echo({ { "Failed to require the following files:", "None" } }, false, {})
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

M.cpu_count = function()
  if vim.fn.executable("grep") ~= 0 then
    local file = io.popen("grep -c processor /proc/cpuinfo")
    if file == nil then
      return
    end
    local numcpus = file:read()
    file:close()
    return tonumber(numcpus, 10)
  end
end
return M
