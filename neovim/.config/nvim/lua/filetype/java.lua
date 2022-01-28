vim.api.nvim_command([[autocmd BufNewFile *.java exe "normal Ipublic class " . expand('%:t:r') . "{\n}\<Esc>1G"]])
vim.api.nvim_command([[autocmd FileType java setlocal autoindent shiftwidth=0]])
