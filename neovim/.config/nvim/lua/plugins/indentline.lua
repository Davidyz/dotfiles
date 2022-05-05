local utils = require("utils")
require("packer")

vim.g.indentLine_leadingSpaceChar = "_"
vim.g.indentLine_char = "┆"

if utils.contains(SOURCE_CODE, vim.bo.filetype) then
  vim.g.indentLine_enabled = 1
else
  vim.g.indentLine_enabled = 0
end

vim.g.indentLine_setColor = 1
vim.g.indentLine_leadingSpaceEnabled = 1
vim.g.indentLine_setConceal = 1
vim.g.vim_json_conceal = 0
vim.g.markdown_syntax_conceal = 0

if vim.fn.exists(":IndentLinesToggle") ~= 0 then
  local noIndentLineFt = { "startup", "packer", "startify" }
  for _, ft in ipairs(noIndentLineFt) do
    vim.api.nvim_create_autocmd("FileType", { pattern = ft, command = ":IndentLinesDisable" })
  end

  for _, ft in ipairs(SOURCE_CODE) do
    vim.api.nvim_create_autocmd("FileType", { pattern = ft, command = ":IndentLinesEnable" })
  end

  vim.api.nvim_create_autocmd("TermEnter", { command = ":IndentLinesDisable" })
end
