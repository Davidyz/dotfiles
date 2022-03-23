vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  command = "map <buffer> <F5> :w<CR>:exec '!gcc % -o /tmp/temp.out && /tmp/temp.out && rm /tmp/temp.out'<CR>",
})
