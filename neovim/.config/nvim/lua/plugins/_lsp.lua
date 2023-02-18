local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)
lsp_defaults.capabilities.offsetEncoding = "utf-8"

vim.opt.completeopt = { "menu", "menuone", "noselect" }

require("mason-lspconfig").setup({})
require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup({
      flags = { debounce_text_changes = 150 },
      single_file_support = true,
      capabilities = lsp_defaults.capabilities,
      on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
      end,
    })
  end,
  ["lua_ls"] = function()
    require("lspconfig")["lua_ls"].setup({
      flags = { debounce_text_changes = 150 },
      settings = {
        Lua = {
          format = {
            enable = false,
            default_config = {
              indent_style = "space",
              indent_size = "2",
            },
          },
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end,
})
