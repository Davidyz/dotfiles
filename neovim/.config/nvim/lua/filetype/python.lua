vim.api.nvim_command([[autocmd BufNewFile *.py exe "normal I\nif __name__ == '__main__':" .  "\n    pass\<Esc>1G"]])
vim.api.nvim_command([[autocmd FileType py setlocal ts=4 expandtab autoindent :highlight ColorColumn ctermbg=magenta :call matchadd('ColorColumn', '\%81v', 80)]])
