vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "pandoc,markdown", command = "setlocal tw=80 ts=2 sts=2 expandtab autoindent" }
)
vim.api.nvim_create_autocmd("BufEnter", { pattern = "*.md", command = "set filetype=markdown.pandoc" })
