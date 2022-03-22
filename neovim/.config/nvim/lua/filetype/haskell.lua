vim.api.nvim_create_autocmd("FileType", { pattern = "haskell", command = "setlocal ts=2 autoindent" })
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.hs", callback = format("fourmolu") })
