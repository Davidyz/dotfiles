local utils = require("_utils")

if vim.fn.has("unix") ~= 0 then
  if vim.fn.executable("python") and os.execute('python -c "import neovim" 2> /dev/null') ~= 0 then
    os.execute("python -m pip install neovim > /dev/null")
    print("neovim Python API installed.")
  end
end

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
vim.g.packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  vim.g.packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

local items = {
  "colorscheme.main",
  "plugins.main",
  "keymaps.main",
  "filetype.main",
  "misc",
}
utils.tryRequire(items)
