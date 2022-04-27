local utils = require("utils")

if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
end
vim.opt.background = "dark"

utils.Require("colorscheme.onedark")
