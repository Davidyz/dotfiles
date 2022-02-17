require('os')

HOME = os.getenv('HOME')

SOURCE_CODE = {'java', 'c', 'cpp', 'python', 'hs', 'sh', 'go', 'php', 'json', 'bash', 'zsh', 'vim', 'lua'}
TEXT = {'md', 'txt', 'markdown', 'rmd', 'pandoc', 'text'}

function List_contains(array, element)
  for _, value in pairs(array) do
    if value == element then
      return true
    end
  end
  return false
end

function GetHostname()
  local f = io.popen ("/bin/hostname")
  local hostname = f:read("*a") or ""
  f:close()
  hostname =string.gsub(hostname, "\n$", "")
  return hostname
end

function GetUserName()
  local username = vim.fn.getenv('USER')
  if username == nil then
    username = vim.fn.getenv('USERNAME')
  end
  return username
end

function Get_ColorCode(group, tag)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), tag)
end
