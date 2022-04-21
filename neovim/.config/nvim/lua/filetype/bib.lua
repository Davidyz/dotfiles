require("filetype.utils")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.bib",
  callback = format("bibtool", ""),
})
