local utils = require("_utils")
require("nvim-treesitter.install").prefer_git = true

local installed_list = {}
if utils.cpu_count() >= 4 then
  installed_list = {
    "python",
    "c",
    "comment",
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
    "regex",
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
  auto_install = true,
  sync_install = true,
  ignore_install = { "csv" },
  modules = { "highlight", "illuminate", "indent", "incremental_selection", "refactor" },
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
  indent = true,
  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<TAB>",
      scope_incremental = false,
      node_decremental = "<S-TAB>",
    },
  },
  matchup = { enable = true },
})
