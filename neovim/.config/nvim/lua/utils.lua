require("os")

HOME = os.getenv("HOME")

SOURCE_CODE = { "java", "c", "cpp", "python", "hs", "sh", "go", "php", "json", "bash", "zsh", "vim", "lua", "make" }
TEXT = { "md", "txt", "markdown", "rmd", "pandoc", "text" }

function List_contains(array, element)
  for _, value in pairs(array) do
    if value == element then
      return true
    end
  end
  return false
end

function IsSourceCode(filetype)
  return List_contains(SOURCE_CODE, filetype)
end

function GetHostname()
  local f = io.popen("/bin/hostname")
  local hostname = f:read("*a") or ""
  f:close()
  hostname = string.gsub(hostname, "\n$", "")
  return hostname
end

function GetUserName()
  local username = vim.fn.getenv("USER")
  if username == nil then
    username = vim.fn.getenv("USERNAME")
  end
  return username
end

function Get_ColorCode(group, tag)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), tag)
end

function GetTermCode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function SendKey(str, mode, escape)
  if escape == nil then
    escape = false
  end
  return vim.api.nvim_feedkeys(string, mode, escape)
end

function Require(item)
  if not type(item) == "string" then
    return false
  end
  local status, error_message = pcall(require, item)
  return status
end

function TryRequire(items, retry_count)
  if retry_count == 0 then
    vim.api.nvim_echo({ { "Failed to require the following files:", "None" } }, false, {})
    for _, item in ipairs(items) do
      vim.api.nvim_echo({ { item, "None" } }, false, {})
    end
    return
  end
  retry_count = retry_count or 10
  local failed = {}
  for _, item in ipairs(items) do
    local status = Require(item)
    if not status then
      table.insert(failed, item)
    end
  end
  if table.getn(failed) > 0 then
    TryRequire(failed, retry_count - 1)
  end
end
