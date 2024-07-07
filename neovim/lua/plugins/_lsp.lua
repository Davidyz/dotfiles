local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config
local lsp_utils = lspconfig.util
local utils = require("_utils")

lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)
lsp_defaults.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

vim.opt.completeopt = { "menu", "menuone", "noselect" }
local default_server_config = {
  flags = { debounce_text_changes = 150 },
  single_file_support = true,
  capabilities = lsp_defaults.capabilities,

  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end
    if client.server_capabilities.inlayHintProvider and vim.bo.filetype ~= "tex" then
      vim.g.inlay_hints_visible = true
      local status, err = pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
      if not status then
        vim.lsp.inlay_hint.enable(bufnr, true)
      end
    end
    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
    end
  end,
}

require("mason-lspconfig").setup({ autostart = true })

local handlers = {
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup(default_server_config)
  end,
  ["rust_analyzer"] = function()
    require("lspconfig")["rust_analyzer"].setup(
      vim.tbl_deep_extend(
        "force",
        default_server_config,
        { root_dir = lsp_utils.root_pattern("Cargo.toml", ".git") }
      )
    )
  end,
  ["texlab"] = function()
    require("lspconfig")["texlab"].setup(
      vim.tbl_deep_extend("force", default_server_config, {
        texlab = {
          formatterLineLength = 88,
          latexindent = {
            ["local"] = ".latexindent.yaml",
            modifyLineBreaks = true,
          },
        },
      })
    )
  end,
  ["basedpyright"] = function()
    lspconfig["basedpyright"].setup(
      vim.tbl_deep_extend("force", default_server_config, {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              inlayHints = {
                callArgumentNames = "all",
                functionReturnTypes = true,
                pytestParameters = true,
                variableTypes = true,
              },
              autoFormatStrings = true,
            },
            linting = { enabled = false },
            typeCheckingMode = "standard",
          },
        },
      })
    )
  end,
  ["ruff_lsp"] = function()
    lspconfig["ruff_lsp"].setup(vim.tbl_deep_extend("force", default_server_config, {
      capabilities = {
        -- only enable when black is not available
        textDocument = { dynamicRegistration = vim.fn.executable("black") == 0 },
      },
    }))
  end,
  ["arduino_language_server"] = function()
    if
      vim.fn.filereadable(vim.fn.expand("~/.arduino15/arduino-cli.yaml")) == 0
      and vim.fn.executable("arduino-cli")
    then
      vim.fn.system("arduino-cli config init")
    end
    local arduino_config = vim.tbl_deep_extend("force", default_server_config, {
      cmd = {
        "arduino-language-server",
        "-cli",
        vim.fn.exepath("arduino-cli"),
        "-clangd",
        vim.fn.exepath("clangd"),
        "-cli-config",
        "~/.arduino15/arduino-cli.yaml",
      },
      capabilities = { workspace = { semanticTokens = nil } },
    })
    lspconfig["arduino_language_server"].setup(arduino_config)
  end,
  ["lua_ls"] = function()
    local lua_config = vim.tbl_deep_extend("force", default_server_config, {
      flags = { debounce_text_changes = 150 },
      settings = {
        Lua = {
          format = {
            enable = false,
            defaultConfig = {
              indent_style = "space",
              indent_size = 2,
              quote_style = "double",
            },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = { vim.fn.expand("~/.config/nvim/lua/user/types/wezterm/") },
            useGitIgnore = true,
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
          hint = { enable = true },
        },
      },
    })
    require("lspconfig")["lua_ls"].setup(lua_config)
  end,
  ["bashls"] = function()
    local ls_executable = { "bash-language-server", "start" }
    if
      vim.fn.executable("termux-language-server")
      and (vim.tbl_contains({ "PKGBUILD" }, vim.fn.expand("%:t")))
    then
      ls_executable = { "termux-language-server", "--indent", vim.bo.sts }
    end
    local bash_config =
      vim.tbl_deep_extend("force", default_server_config, { cmd = ls_executable })
    lspconfig["bashls"].setup(bash_config)
  end,
  ["ltex"] = function()
    if vim.fn.isdirectory(vim.fn.expand("~/.local/share/ltex/")) ~= 1 then
      vim.fn.mkdir(vim.fn.expand("~/.local/share/ltex/"), "p")
    end
    local ltex_config = vim.tbl_deep_extend("force", default_server_config, {
      on_attach = function(client, bufnr)
        default_server_config.on_attach(client, bufnr)
        require("ltex_extra").setup({
          load_langs = { "en-GB", "zh-CN" },
          init_check = true,
          path = vim.fn.expand("~") .. "/.local/share/ltex",
          log_level = "none",
          server_opts = nil,
        })
      end,
      ltex = { language = "en-GB" },
    })
    lspconfig["ltex"].setup(ltex_config)
  end,
}

require("mason-lspconfig").setup_handlers(handlers)

vim.api.nvim_create_autocmd(
  { "CursorHold", "CursorMoved", "CursorHoldI", "CursorMovedI" },
  {
    callback = function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local server_supported = utils.any(clients, function(c)
        local capability = c.server_capabilities.documentHighlightProvider
        return capability ~= nil and capability ~= false
      end)
      if #clients > 1 and server_supported then
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end
    end,
  }
)
