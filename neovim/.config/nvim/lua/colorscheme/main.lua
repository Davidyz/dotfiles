if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
end
vim.opt.background = "dark"

require("utils")
Require("colorscheme.onedark")
