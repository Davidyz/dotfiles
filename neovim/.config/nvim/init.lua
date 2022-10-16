local utils = require("_utils")

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
