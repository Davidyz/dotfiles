vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "lua", command = "setlocal ts=2 autoindent softtabstop=2 shiftwidth=2" }
)
vim.api.nvim_create_autocmd(
  "BufWritePre",
  { pattern = "*.lua", callback = format("stylua", "--indent-type Spaces --indent-width 2 -") }
)
