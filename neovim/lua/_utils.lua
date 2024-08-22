local M = {}

TEXT = { "markdown", "md", "pandoc", "rmd", "tex", "text", "txt" }

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

---@param items string[]
---@param retry_count integer
function M.tryRequire(items, retry_count)
  if retry_count == 0 then
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
  return {}
end

---@return integer
M.cpu_count = function()
  if vim.uv == nil or vim.uv.cpu_info == nil then
    return #vim.loop.cpu_info()
  end
  return #vim.uv.cpu_info()
end

---@return boolean
M.no_vscode = function()
  return vim.g.vscode == nil
end

---@return 'linux'|'mac'|'win'|'unknown'
M.platform = function()
  if vim.fn.has("linux") == 1 then
    return "linux"
  elseif vim.fn.has("mac") == 1 then
    return "mac"
  elseif vim.fn.has("win32") == 1 then
    return "win"
  else
    return "unknown"
  end
end

---@return boolean
function M.is_basic_ssh()
  return vim.fn.environ()["FANCY_TERM"] == nil
    and vim.fn.environ()["SSH_CONNECTION"] ~= nil
end

M.codicons = {
  Array = "  ",
  Boolean = "  ",
  Class = "  ",
  Clipboard = "  ",
  Color = "  ",
  Constant = "  ",
  Constructor = "  ",
  Enum = "  ",
  EnumMember = "  ",
  Event = "  ",
  Field = "  ",
  File = "  ",
  Folder = "  ",
  Function = "  ",
  Interface = "  ",
  Key = "  ",
  Keyword = "  ",
  Method = "  ",
  Module = "  ",
  Namespace = "  ",
  Null = "  ",
  Number = "  ",
  Object = "  ",
  Operator = "  ",
  Package = "  ",
  Property = "  ",
  Reference = "  ",
  Snippet = "  ",
  String = "  ",
  Struct = "  ",
  Text = "  ",
  TypeParameter = "  ",
  Unit = "  ",
  Value = "  ",
  Variable = "  ",
}

return M
