local utils = require("_utils")

require("plugins.packer_nvim")
require("packer")

local packer_user_config = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd(
  "BufWritePost",
  { pattern = "packer.lua", command = "source <afile> | PackerCompile", group = packer_user_config }
)

local items = {
  "plugins.black",
  "plugins.coc-nvim",
  -- "plugins.copilot",
  -- "plugins.fauxpilot",
  "plugins.dap",
  "plugins.golden_view",
  "plugins.haskell",
  "plugins.indentline",
  "plugins.jupytext",
  "plugins._lualine",
  "plugins.markdown_preview",
  "plugins.NERDTree",
  "plugins.nvim_autopairs",
  "plugins.pandoc",
  "plugins.rainbow",
  "plugins.startify",
  "plugins.tree_sitter",
  "plugins.treesitter-context",
}
utils.tryRequire(items)

--for _, i in ipairs(items) do
--require(i)
--end
