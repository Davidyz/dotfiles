local utils = require("utils")
require("plugins.packer")
local packer_user_config = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd(
  "BufWritePost",
  { pattern = "packer.lua", command = "source <afile> | PackerCompile", group = packer_user_config }
)

local items = {
  "plugins.black",
  "plugins.coc-nvim",
  "plugins.copilot",
  "plugins.golden_view",
  "plugins.haskell",
  "plugins.indentline",
  "plugins.jupytext",
  "plugins.lualine",
  "plugins.markdown_preview",
  "plugins.nvim_autopairs",
  "plugins.nvim_gps",
  "plugins.NERDTree",
  "plugins.pandoc",
  "plugins.rainbow",
  "plugins.startify",
  "plugins.tree_sitter",
  "plugins.treesitter-context",
}
utils.tryRequire(items)
