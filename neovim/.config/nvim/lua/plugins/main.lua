local utils = require("_utils")
local lazy_config = require("plugins._lazy")

require("lazy").setup(lazy_config.plugins, lazy_config.config)

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
