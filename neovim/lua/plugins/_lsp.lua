local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config
local lsp_utils = lspconfig.util

lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)
lsp_defaults.capabilities.offsetEncoding = "utf-8"
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
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
    end
  end,
}

require("mason-lspconfig").setup({ autostart = true })

local handlers = {
  function(server_name) -- default handler (optional)
    if server_name == "rust_analyzer" then
      default_server_config.root_dir = lsp_utils.root_pattern("Cargo.toml", ".git")
    end
    require("lspconfig")[server_name].setup(default_server_config)
  end,
  ["texlab"] = function()
    default_server_config.settings = {
      texlab = {
        formatterLineLength = 88,
        latexindent = {
          ["local"] = ".latexindent.yaml",
          modifyLineBreaks = true,
        },
      },
    }
    require("lspconfig")["texlab"].setup(default_server_config)
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
      vim.fn.filereadable("~/.arduino15/arduino-cli.yaml") ~= 0
      and vim.fn.executable("arduino-cli")
    then
      vim.fn.execute("arduino-cli config init")
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
    })
    arduino_config.capabilities.workspace.semanticTokens = nil
    lspconfig["arduino_language_server"].setup(arduino_config)
  end,
  ["lua_ls"] = function()
    local libs = vim.api.nvim_get_runtime_file("", true)
    if string.find(vim.fn.expand("%:p"), "wezterm") then
      table.insert(libs, vim.fn.expand("~/.config/nvim/lua/user/types/wezterm/"))
    end
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
            library = libs,
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
}
local default_pyright_config = vim.tbl_deep_extend("force", default_server_config, {
  settings = {
    python = {
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
    },
  },
})

if vim.fn.executable("basedpyright-langserver") == 1 then
  local based_config = vim.tbl_deep_extend(
    "force",
    default_pyright_config,
    { settings = { basedpyright = default_pyright_config.settings.python } }
  )
  based_config.settings.basedpyright.typeCheckingMode = "standard"
  lspconfig["basedpyright"].setup(based_config)
else
  local lang_server = "pyright-langserver"
  if vim.fn.executable("delance-langserver") ~= 0 then
    lang_server = "delance-langserver"
  end

  local pyright_config = vim.tbl_deep_extend("force", default_pyright_config, {
    cmd = { lang_server, "--stdio" },
  })
  lspconfig.pyright.setup(pyright_config)
end

require("mason-lspconfig").setup_handlers(handlers)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lspinfo",
  callback = function()
    vim.api.nvim_win_set_config(0, { border = "double" })
  end,
})
