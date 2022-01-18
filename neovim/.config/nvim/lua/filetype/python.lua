vim.api.nvim_command([[autocmd BufNewFile *.py exe "normal I\nif __name__ == '__main__':" .  "\npass\<Esc>1G"]])
