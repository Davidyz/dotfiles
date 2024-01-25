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

require("mason-lspconfig").setup({ autostart = true })
require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    local server_config = {
      flags = { debounce_text_changes = 150 },
      single_file_support = true,
      capabilities = lsp_defaults.capabilities,

      on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
      end,
    }
    if server_name == "rust_analyzer" then
      server_config.root_dir = lsp_utils.root_pattern("Cargo.toml", ".git")
    end
    require("lspconfig")[server_name].setup(server_config)
  end,
  ["lua_ls"] = function()
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "?.lua")
    table.insert(runtime_path, "?/init.lua")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    local libs = vim.api.nvim_get_runtime_file("", true)
    if string.find(vim.fn.expand("%:p"), "wezterm") then
      table.insert(libs, vim.fn.expand("~/.config/nvim/lua/user/types/wezterm/"))
    end
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
            library = libs,
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lspinfo",
  callback = function()
    vim.api.nvim_win_set_config(0, { border = "double" })
  end,
})
