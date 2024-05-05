vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  command = [[map <buffer> <F5> :w<CR>:exec '!sh' shellescape(@%, 1)<CR>"]],
})
