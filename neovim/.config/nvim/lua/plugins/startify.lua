local utils = require("_utils")
vim.api.nvim_create_autocmd("TabNewEntered", {
  pattern = "*",
  callback = function()
    local pokemon = require("pokemon")
    pokemon.setup({ size = "small" })
    local header = pokemon.header()
    table.insert(header, string.rep(" ", 3) .. pokemon.pokemon.name)
    vim.g.startify_custom_header = header
    vim.fn["startify#insane_in_the_membrane"](0)
  end,
})

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
