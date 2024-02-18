local utils = require("_utils")
local lazy_config = require("plugins._lazy")

if vim.loader ~= nil and type(vim.loader.enable) == "function" then
  vim.loader.enable()
end

if vim.fn.has("win32") == 1 then
  local powershell_options = {
    shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
end

if vim.fn.has("unix") ~= 0 then
  if
    vim.fn.executable("python")
    and os.execute('python -c "import neovim" 2> /dev/null') ~= 0
  then
    os.execute("python -m pip install neovim > /dev/null")
    print("neovim Python API installed.")
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(lazy_config.plugins, lazy_config.config)

local items = {
  "keymaps.main",
  "filetype.main",
  "misc",
}
utils.tryRequire(items)
