local utils = require("_utils")
local lazy_config = require("plugins._lazy")

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
  "colorscheme.main",
  "keymaps.main",
  "filetype.main",
  "misc",
}
utils.tryRequire(items)
