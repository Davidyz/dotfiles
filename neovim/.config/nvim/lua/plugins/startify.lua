require("utils")
vim.api.nvim_create_autocmd("TabNewEntered", { pattern = "*", command = "Startify" })

vim.api.nvim_command([[
function! StartifyEntryFormat()
  return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
]])

vim.g.startify_lists = {
  {
    ["type"] = "dir",
    ["header"] = { "   Current directory: " },
  },
  {
    ["type"] = "files",
    ["header"] = { "   History: " },
  },
}
