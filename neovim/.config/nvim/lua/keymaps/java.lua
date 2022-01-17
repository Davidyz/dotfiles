require('keymaps.utils')
vim.api.nvim_command("autocmd FileType java map <buffer> <F5> :w<CR>:exec '!java' shellescape(@%, 1)<CR>")
