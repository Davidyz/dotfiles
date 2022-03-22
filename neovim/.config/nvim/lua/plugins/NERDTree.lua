vim.g.NERDCreateDefaultMappings = 1
vim.g.NERDSpaceDelims = 1
vim.g.NERDTrimTrailingWhitespace = 1

vim.api.nvim_create_autocmd(
  "BufWinEnter",
  { pattern = "*", command = [[if getcmdwintype() == '' | silent NERDTreeMirror | endif]] }
)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = [[if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]],
})
vim.api.nvim_create_autocmd("BufEnter", { pattern = "NERD_tree*", command = ":LeadingSpaceDisable" })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "NERD_tree*",
  callback = function()
    vim.g.rainbow_active = 0
  end,
})
vim.api.nvim_create_autocmd(
  "BufEnter",
  { pattern = "*", command = [[if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]] }
)
