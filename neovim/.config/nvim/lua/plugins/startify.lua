local utils = require("_utils")
vim.api.nvim_create_autocmd("TabNewEntered", { pattern = "*", command = "Startify" })

if vim.fn.exists(":Startify") ~= 0 then
  vim.api.nvim_command([[
function! StartifyEntryFormat()
  return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
]])
end

vim.g.startify_lists = {
  { ["type"] = "commands", ["header"] = { "   Commands" } },
  { type = utils.gitModified, header = { "   Git Modified:" } },
  { type = utils.gitUntracked, header = { "   Git Untracked:" } },
  {
    ["type"] = "dir",
    ["header"] = { "   Current directory: " },
  },
  {
    ["type"] = "files",
    ["header"] = { "   History: " },
  },
}
vim.g.startify_commands = {
  { ["t"] = "terminal" },
}
