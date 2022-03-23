require("utils")

local function no_trailing_spaces()
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

vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", callback = no_trailing_spaces })

local items = {
  "filetype.json",
  "filetype.xml",
  "filetype.yaml",

  "filetype.c_cpp",
  "filetype.java",
  "filetype.lua",
  "filetype.haskell",
  "filetype.php",
  "filetype.python",
  "filetype.sh",
  "filetype.typescript",
  "filetype.vim",
  "filetype.zsh",

  "filetype.gitcommit",
  "filetype.pandoc",
  "filetype.markdown",
  "filetype.html",
}
TryRequire(items)
