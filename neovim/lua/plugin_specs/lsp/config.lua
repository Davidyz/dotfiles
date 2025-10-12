---@module "lazy"

local utils = require("_utils")

---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    version = "*",
    config = function()
      require("keymaps._lsp")
      require("lspconfig.ui.windows").default_options.border = { " " }
    end,
    event = { "BufReadPre", "BufNewFile", "CmdlineEnter" },
    cond = require("_utils").no_vscode,
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "*",
    event = { "BufReadPost", "BufNewFile", "FileType" },
    opts = {
      automatic_enable = { exclude = { "stylua", "rust_analyzer" } },
      ensure_installed = nil,
    },
    cond = require("_utils").no_vscode,
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    cond = function()
      return utils.find_nvim_runtime() == vim.env.VIMRUNTIME
    end,
    opts = function(_, opts)
      ---@type lazydev.Config
      opts = vim.tbl_deep_extend("force", opts or {}, {
        runtime = utils.find_nvim_runtime(),
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { path = "wezterm-types", mods = { "wezterm" } },
          { path = "folke/snacks.nvim", words = { "Snacks" } },
          {
            path = "nvim-lua/plenary.nvim",
            words = {
              "describe",
              "it",
              "pending",
              "before_each",
              "after_each",
              "clear",
              "assert.*",
            },
          },
        },
      })
      return opts
    end,
    config = function(_, opts)
      require("lazydev").setup(opts)
    end,
    dependencies = {
      { "Bilal2453/luvit-meta" },
      { "justinsgithub/wezterm-types" },
      { "folke/snacks.nvim" },
    },
  },
}
