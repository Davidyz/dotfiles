require('plugins.packer')

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require('plugins.tree_sitter')
require('plugins.NERDTree')
require('plugins.coc-nvim')
require('plugins.lualine')
require('plugins.markdown_preview')
require('plugins.startify')
require('plugins.indentline')
require('plugins.pandoc')
require('plugins.haskell')
require('plugins.nvim_autopairs')
