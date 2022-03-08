require("plugins.packer")

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerCompile
  augroup end
]])

require("plugins.black")
require("plugins.coc-nvim")
require("plugins.golden_view")
require("plugins.haskell")
require("plugins.indentline")
require("plugins.jupytext")
require("plugins.lualine")
require("plugins.markdown_preview")
require("plugins.nvim_autopairs")
require("plugins.nvim_gps")
require("plugins.NERDTree")
require("plugins.pandoc")
require("plugins.rainbow")
require("plugins.startify")
require("plugins.tree_sitter")
require("plugins.treesitter-context")
