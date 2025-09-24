local api = vim.api
local diag = vim.diagnostic

---@module "lazy"

---@type LazySpec[]
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
      ---@type conform.setupOpts
      opts = vim.tbl_deep_extend("force", opts or {}, {
        formatters_by_ft = {
          lua = { "stylua" },
          sh = { "shfmt" },
          zsh = { "shfmt" },
          bash = { "shfmt" },
          json = { "fixjson" },
          json5 = { "prettier" },
          jinja = { "djlint" },
          python = function()
            local formatters
            if vim.fn.executable("black") == 1 then
              formatters = { "black" }
              if not vim.b.conform_notified_python_formatter then
                vim.notify(
                  string.format(
                    "Using %s for python formatting.",
                    table.concat(
                      vim
                        .iter(formatters)
                        :map(function(s)
                          return "`" .. s .. "`"
                        end)
                        :totable(),
                      ", "
                    )
                  ),
                  nil,
                  { title = "Conform.nvim" }
                )
                vim.b.conform_notified_python_formatter = true
              end
            else
              formatters = { "ruff_format", "ruff_fix", "ruff_organize_imports" }
            end

            return formatters
          end,
          c = { "clang-format" },
          cpp = { "clang-format" },
          markdown = { "injected" },
          toml = function(bufnr)
            if api.nvim_buf_get_name(bufnr):match("pyproject%.toml$") ~= nil then
              return { "pyproject-fmt" }
            end
            return { "taplo" }
          end,
        },
        formatters = {
          prettier = { prepend_args = { "--quote-props", "preserve" } },
          injected = {
            ignore_errors = true,
          },
        },
      })
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
              require("conform").format({
                lsp_format = "first",
                ---@param client vim.lsp.Client
                filter = function(client)
                  return not vim.tbl_contains({ "ruff" }, client.name, {})
                end,
              }, function(err, did_edit)
                if err ~= nil then
                  local level = vim.log.levels.ERROR
                  if did_edit then
                    level = vim.log.levels.WARN
                  end
                  vim.schedule_wrap(vim.notify)(err, level, { title = "Conform.nvim" })
                end
              end)
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
        python = {},
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
      diag.config({
        float = {
          source = true,
        },
      })
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "rachartier/tiny-inline-diagnostic.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
    event = { "BufReadPost", "BufNewFile" },
  },
}
