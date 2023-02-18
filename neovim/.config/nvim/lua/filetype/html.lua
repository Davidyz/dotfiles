vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "html", command = "setlocal ts=2 autoindent sw=2" }
)
