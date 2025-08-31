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
    cond = require("_utils").no_vscode,
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = function(_, opts)
      opts = vim.tbl_deep_extend("force", opts or {}, {
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
        enabled = function(root_dir)
          return root_dir:match("(%w+)%/?$") ~= "neovim"
        end,
      })
      return opts
    end,
    config = function(_, opts)
      require("lazydev").setup(opts)
      require("lazydev.lsp").supports = function(client)
        return client and vim.tbl_contains({ "lua_ls", "emmylua_ls" }, client.name)
      end
    end,
    dependencies = {
      { "Bilal2453/luvit-meta" },
      { "justinsgithub/wezterm-types" },
      { "folke/snacks.nvim" },
    },
  },
}
