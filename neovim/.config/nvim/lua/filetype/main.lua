require("utils")

function NoTrailingSpaces()
  if List_contains(SOURCE_CODE, vim.bo.filetype) then
    local cursor_line = vim.fn.line(".")
    local cursor_col = vim.fn.col(".")
    vim.api.nvim_command(":silent! mkview!")
    vim.api.nvim_command(":silent! %s/ *$//e")
    vim.fn.histdel("cmd", -1)
    vim.api.nvim_command(":silent! loadview!")

    vim.fn.cursor(cursor_line, cursor_col)
  end
end

vim.api.nvim_command("autocmd BufWritePre * call v:lua.NoTrailingSpaces()")

require("filetype.json")
require("filetype.xml")
require("filetype.yaml")

require("filetype.c_cpp")
require("filetype.java")
require("filetype.lua")
require("filetype.haskell")
require("filetype.php")
require("filetype.python")
require("filetype.sh")
require("filetype.typescript")
require("filetype.vim")
require("filetype.zsh")

require("filetype.gitcommit")
require("filetype.pandoc")
require("filetype.markdown")
require("filetype.html")
