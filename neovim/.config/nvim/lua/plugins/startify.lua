vim.api.nvim_create_autocmd("TabNewEntered", { pattern = "*", command = "Startify" })

local gitModified = function()
  if vim.fn.has("unix") then
    local files = vim.fn.systemlist("git ls-files -m 2> /dev/null")
    if files then
      return vim.fn.map(files, "{'line': v:val, 'path': v:val}")
    end
  end
end
local gitUntracked = function()
  if vim.fn.has("unix") then
    local files = vim.fn.systemlist("git ls-files -o --exclude-standard 2> /dev/null")
    if files then
      return vim.fn.map(files, "{'line': v:val, 'path': v:val}")
    end
  end
end
if vim.fn.exists(":Startify") ~= 0 then
  vim.api.nvim_command([[
function! StartifyEntryFormat()
  return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
]])
end

vim.g.startify_lists = {
  { ["type"] = "commands", ["header"] = { "   Commands" } },
  { type = gitModified, header = { "   Git Modified" } },
  { type = gitUntracked, header = { "   Git Untracked" } },
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
