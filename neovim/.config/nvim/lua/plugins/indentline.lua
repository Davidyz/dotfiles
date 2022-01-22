require('utils')
vim.g.indentLine_leadingSpaceChar = '.'
vim.g.indentLine_char = '┆'

if List_contains(SOURCE_CODE, vim.bo.filetype) then
  vim.g.indentLine_setConceal = 0
  vim.g.indentLine_enabled = 1
else
  vim.g.indentLine_setConceal = 1
  vim.g.indentLine_enabled = 0
end

vim.g.indentLine_setColor = 1
vim.g.indentLine_leadingSpaceEnabled = 1