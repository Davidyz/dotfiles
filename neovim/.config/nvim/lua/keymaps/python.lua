require("keymaps.utils")

vim.api.nvim_command("autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>")
