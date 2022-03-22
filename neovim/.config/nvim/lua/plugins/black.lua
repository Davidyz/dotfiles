vim.g.black_linelength = 79
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.py", command = "Black" })
