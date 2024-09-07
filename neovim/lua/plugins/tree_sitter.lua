local utils = require("_utils")
require("nvim-treesitter.install").prefer_git = true

local installed_list = {}
if utils.cpu_count() >= 4 then
  installed_list = {
    "python",
    "c",
    "comment",
    "cpp",
    "gitcommit",
    "javascript",
    "json5",
    "make",
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
  modules = { "highlight", "illuminate", "indent", "incremental_selection" },
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
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<TAB>",
      node_incremental = "<TAB>",
      scope_incremental = false,
      node_decremental = "<S-TAB>",
    },
  },
  matchup = { enable = true },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "Select function" },
        ["if"] = { query = "@function.inner", desc = "Select inner function" },
        ["ac"] = {
          query = "@class.outer",
          desc = "Select class",
        },
        ["ic"] = {
          query = "@class.inner",
          desc = "Select inner part of a class region",
        },
        ["as"] = {
          query = "@scope",
          query_group = "locals",
          desc = "Select language scope",
        },
        ["il"] = { query = "@loop.inner", desc = "Select inner loop" },
        ["al"] = { query = "@loop.outer", desc = "Select loop" },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    lsp_interop = {
      enable = true,
      border = "none",
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
})
