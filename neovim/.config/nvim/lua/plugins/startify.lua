require("utils")
if vim.fn.has("nvim") then
  vim.api.nvim_command([[au! TabNewEntered * Startify]])
end

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
