vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "yaml", command = "setlocal ts=2 sts=2 autoindent sw=2" }
)

vim.filetype.add({ pattern = { [".*/.github/workflows/.*%.yml"] = "yaml.ghaction" } })
