vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "php", command = "setlocal autoindent sts=2 ts=2 sw=2" }
)
