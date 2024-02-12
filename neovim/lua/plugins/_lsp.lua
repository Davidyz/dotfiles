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
require("mason-lspconfig").setup_handlers({
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
  ["lua_ls"] = function()
    --local runtime_path = vim.split(package.path, ";")
    --table.insert(runtime_path, "?.lua")
    --table.insert(runtime_path, "?/init.lua")
    --table.insert(runtime_path, "lua/?.lua")
    --table.insert(runtime_path, "lua/?/init.lua")
    local libs = vim.api.nvim_get_runtime_file("", true)
    if string.find(vim.fn.expand("%:p"), "wezterm") then
      table.insert(libs, vim.fn.expand("~/.config/nvim/lua/user/types/wezterm/"))
    end
    local lua_config = vim.tbl_deep_extend("force", default_server_config, {
      flags = { debounce_text_changes = 150 },
      settings = {
        Lua = {
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
        },
      },
    })
    require("lspconfig")["lua_ls"].setup(lua_config)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lspinfo",
  callback = function()
    vim.api.nvim_win_set_config(0, { border = "double" })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "PKGBUILD",
  callback = function()
    if vim.fn.executable("termux-language-server") == 1 then
      require("lspconfig").pkgbuild_language_server.setup({
        cmd = { "termux-language-server", "--convert", "PKGBUILD" },
        filetypes = { "sh" },
      })
    end
  end,
})
