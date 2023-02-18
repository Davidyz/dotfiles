local utils = require("_utils")
-- require("packer")

vim.g.indentLine_leadingSpaceChar = " "
vim.g.indentLine_char = "┆"

vim.g.indentLine_setColor = 1
vim.g.indentLine_leadingSpaceEnabled = 1
vim.g.indentLine_setConceal = 1
vim.g.vim_json_conceal = 0
vim.g.markdown_syntax_conceal = 0

if vim.fn.exists(":IndentLinesToggle") ~= 0 then
  local noIndentLineFt = { "startup", "packer", "startify", "help" }
  for _, ft in ipairs(noIndentLineFt) do
    vim.api.nvim_create_autocmd(
      "FileType",
      { pattern = ft, command = ":IndentLinesDisable" }
    )
  end

  for _, ft in ipairs(SOURCE_CODE) do
    vim.api.nvim_create_autocmd(
      "FileType",
      { pattern = ft, command = ":IndentLinesEnable" }
    )
  end

  vim.api.nvim_create_autocmd("TermEnter", { command = ":IndentLinesDisable" })
end
