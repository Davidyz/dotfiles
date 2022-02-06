vim.g.black_linelength = 80
vim.api.nvim_command([[autocmd BufWritePre *.py Black]])
