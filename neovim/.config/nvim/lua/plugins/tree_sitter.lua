local utils = require("utils")
require("nvim-treesitter.install").prefer_git = true

local installed_list = {}
if utils.cpu_count() >= 4 then
  installed_list = { "all" }
end

require("nvim-treesitter.configs").setup({
  ensure_installed = installed_list,
  playground = {
    enable = true,
    updatetime = 25,
    disable = TEXT,
    persist_queries = true,
  },
  highlight = {
    enable = true,
    custom_captures = {},
    additional_vim_regex_highlighting = false,
  },
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
  },
  indent = true,
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
