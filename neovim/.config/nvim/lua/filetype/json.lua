require("filetype.utils")

vim.g.vim_json_conceal = 0
vim.api.nvim_command([[autocmd FileType json setlocal ts=2 sts=2 expandtab autoindent shiftwidth=0 softtabstop=-1]])
