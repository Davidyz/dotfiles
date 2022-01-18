vim.api.nvim_command([[autocmd BufNewFile *.java exe "normal Ipublic class " . expand('%:t:r') . "{\n}\<Esc>1G"]])
