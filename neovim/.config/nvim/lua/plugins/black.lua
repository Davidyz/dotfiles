vim.g.black_linelength = 79
vim.api.nvim_command([[autocmd BufWritePre *.py Black]])
