local ft_utils = require("filetype.utils")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.bib",
  callback = ft_utils.format("bibtool", ""),
})
