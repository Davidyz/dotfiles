vim.api.nvim_command([[autocmd FileType lua setlocal ts=2 autoindent softtabstop=2 shiftwidth=2]])
vim.api.nvim_command([[autocmd FileType lua autocmd BufWritePre *.lua :call v:lua.format('stylua', '-')()]])
