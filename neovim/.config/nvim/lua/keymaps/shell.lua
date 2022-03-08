require("keymaps.utils")

vim.api.nvim_command("autocmd FileType sh map <buffer> <F5> :w<CR>:exec '!sh' shellescape(@%, 1)<CR>")
