vim.g.NERDCreateDefaultMappings = 1
vim.g.NERDSpaceDelims = 1
vim.g.NERDTrimTrailingWhitespace = 1

vim.api.nvim_command([[
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufEnter NERD_tree* :LeadingSpaceDisable
autocmd BufEnter NERD_tree* :let g:rainbow_active = 0
]])
