local utils = require("_utils")
local plugin_utils = require("plugins.utils")

vim.api.nvim_create_autocmd("TabNewEntered", {
  pattern = "*",
  callback = function()
    plugin_utils.make_pokemon()
    vim.fn["startify#insane_in_the_membrane"](0)
  end,
})

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
