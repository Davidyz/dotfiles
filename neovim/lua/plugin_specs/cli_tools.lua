return {
  {
    "Davidyz/executable-checker.nvim",
    opts = {},
    event = "VeryLazy",
  },

  {
    "williamboman/mason.nvim",
    version = "*",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mason",
        callback = function()
          vim.o.cursorline = false
        end,
      })
      require("executable-checker").add_executable({ "python3", "npm" }, "mason")
    end,
    opts = {
      ui = { height = 0.8, border = "solid" },
      max_concurrent_jobs = math.min(4, require("_utils").cpu_count()),
      PATH = "append",
    },
    event = { "FileType" },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    opts = {
      auto_update = true,
      ensure_installed = require("_utils").mason_packages,
    },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      { "zapling/mason-conform.nvim", opts = { ignore_install = { "black" } } },
    },
  },
  {
    "stevearc/conform.nvim",
    version = "*",
    opts = function(_, opts)
      opts = vim.tbl_deep_extend("force", opts or {}, {
        formatters_by_ft = {
          lua = { "stylua" },
          sh = { "shfmt" },
          zsh = { "shfmt" },
          bash = { "shfmt" },
          json = { "fixjson" },
          json5 = { "prettier" },
          python = {},
          c = { "clang-format" },
          cpp = { "clang-format" },
        },
        formatters = { prettier = { prepend_args = { "--quote-props", "preserve" } } },
      })
      if vim.fn.executable("black") == 1 then
        vim.list_extend(opts.formatters_by_ft.python, { "black" })
      end
      return opts
    end,
    config = function(_, opts)
      require("conform").setup(opts)
      vim.g.format_on_save = true
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            group = vim.api.nvim_create_augroup(
              string.format("Conform:%d", args.buf),
              { clear = true }
            ),
            callback = function()
              if vim.g.format_on_save == false then
                return
              end
              require("conform").format({ lsp_format = "first" })
            end,
          })
        end,
      })
    end,
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        ["*"] = { "editorconfig-checker" },
        cmake = { "cmakelang" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        ["yaml.ghaction"] = { "actionlint" },
        lua = { "selene" },
      }
      vim.api.nvim_create_autocmd({
        "BufReadPost",
        "BufWritePost",
        "InsertEnter",
        "InsertLeave",
        "TextChanged",
        "TextChangedI",
        "CursorMoved",
        "CursorMovedI",
      }, {
        callback = function()
          if vim.bo.filetype ~= "lua" or (vim.fs.root(0, { "selene.toml" }) ~= nil) then
            lint.try_lint()
          end
        end,
      })
    end,
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
    event = { "BufReadPost", "BufNewFile" },
  },
}
