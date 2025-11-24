local utils = require("_utils")

---@module "lazy"
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
    opts = function(_, opts)
      opts = vim.tbl_deep_extend("force", opts or {}, {
        ensure_installed = nil,
      }) --[[@as table]]
      opts.automatic_enable = opts.automatic_enable or {}
      opts.automatic_enable.exclude =
        vim.list_extend(opts.automatic_enable, { "stylua", "rust_analyzer" })

      -- NOTE: use emmylua_ls if explicitly supported (have .emmyrc.json) in project root
      local has_emmy = vim.fn.executable("emmylua_ls") == 1
      if vim.fs.root(".", { ".emmyrc.json" }) ~= nil and has_emmy then
        table.insert(opts.automatic_enable.exclude, "lua_ls")
      elseif has_emmy then
        table.insert(opts.automatic_enable.exclude, "emmylua_ls")
      end

      return opts
    end,
    cond = require("_utils").no_vscode,
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    lazy = false,
    cond = function()
      return utils.find_nvim_runtime() == vim.env.VIMRUNTIME
    end,
    ---@param opts? lazydev.Config|{}
    opts = function(_, opts)
      ---@type lazydev.Config
      opts = vim.tbl_deep_extend("force", opts or {}, {
        runtime = utils.find_nvim_runtime(),
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { path = "wezterm-types", mods = { "wezterm" } },
          { path = "folke/snacks.nvim", words = { "Snacks" } },
          {
            path = "codecompanion.nvim",
            words = { "codecompanion", "CodeCompanion" },
          },
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
