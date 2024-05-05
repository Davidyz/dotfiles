vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  command = "setlocal ts=2 expandtab autoindent | let g:indentLine_setConceal=0",
})
