local ft_utils = require("filetype.utils")

vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "python", command = "setlocal ts=4 sts=4 expandtab autoindent" }
)
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.ipynb",
  callback = function()
    vim.bo.filetype = "ipynb,python"
  end,
})
