vim.api.nvim_command([[autocmd FileType haskell setlocal ts=2 autoindent]])
vim.api.nvim_command([[autocmd FileType haskell autocmd BufWritePre * call v:lua.format('fourmolu')()]])
