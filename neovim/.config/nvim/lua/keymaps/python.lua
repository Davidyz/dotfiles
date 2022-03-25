require("keymaps.utils")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  command = [[map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>"]],
})
