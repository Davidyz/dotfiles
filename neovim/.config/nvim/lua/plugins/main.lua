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
  -- "plugins.copilot",
  -- "plugins.fauxpilot",
  "plugins.haskell",
  "plugins.indentline",
  "plugins.nvim_autopairs",
  "plugins.pandoc",
  "plugins.rainbow",
  "plugins.tree_sitter",
  "plugins.treesitter-context",
}
utils.tryRequire(items)

local no_vscode = {
  "plugins.jupytext",
  "plugins.dap",
  "plugins.golden_view",
  "plugins._lsp",
  "plugins._lualine",
  "plugins.markdown_preview",
  "plugins.NERDTree",
  "plugins.startify",
}

if vim.fn.has("g:vscode") == 0 then
  utils.tryRequire(no_vscode)
end
