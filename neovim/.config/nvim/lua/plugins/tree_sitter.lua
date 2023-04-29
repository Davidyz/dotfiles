local utils = require("_utils")
require("nvim-treesitter.install").prefer_git = true

local installed_list = {}
if utils.cpu_count() >= 4 then
  installed_list = {
    "python",
    "c",
    "cmake",
    "bibtex",
    "arduino",
    "cpp",
    "dockerfile",
    "gitcommit",
    "html",
    "java",
    "javascript",
    "json5",
    "latex",
    "make",
    "php",
    "rust",
    "lua",
    "toml",
    "markdown_inline",
    "vim",
    "yaml",
    "vimdoc",
    "git_rebase",
    "gitattributes",
  }
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
  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
  },
  rainbow = {
    enable = true,
    strategy = require("ts-rainbow").strategy["local"],
  },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
