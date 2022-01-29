vim.api.nvim_command([[autocmd BufAdd NERD_tree_*,*.json :let b:vim_current_word_disabled_in_this_buffer = 1]])
vim.api.nvim_command([[highlight CurrentWordTwins guibg=grey guifg=NONE gui=bold]])
vim.api.nvim_command([[highlight CurrentWord guibg=grey guifg=NONE gui=NONE]])
