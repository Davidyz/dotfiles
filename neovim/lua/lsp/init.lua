local lsp = vim.lsp
local methods = lsp.protocol.Methods

vim.opt.completeopt = { "menu", "menuone", "popup" }
lsp.on_type_formatting = lsp.on_type_formatting or require("lsp.on_type_formatting")
lsp.on_type_formatting.enable(true)

---@param client vim.lsp.Client
---@return boolean
local function allow_for_formatting(client)
  local blacklisted_formatter = { "basedpyright", "emmylua_ls" }
  if vim.fn.executable("black") == 1 then
    vim.list_extend(blacklisted_formatter, { "ruff", "ruff_lsp" })
  end
  return not vim.list_contains(blacklisted_formatter, client.name)
end

---@param client vim.lsp.Client
local original_on_attach = function(client, bufnr)
  if allow_for_formatting(client) then
    vim.bo[bufnr].formatexpr = "v:lua.lsp.formatexpr(#{timeout_ms:250})"
  else
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  if not client:supports_method(methods.textDocument_onTypeFormatting, bufnr) then
    lsp.on_type_formatting.enable(false, { client_id = client.id })
  end

  if client:supports_method(methods.textDocument_foldingRange, bufnr) then
    local win = vim.fn.bufwinid(bufnr)
    if win < 0 then
      win = 0
    end
    vim.wo[win][0].foldexpr = "v:lua.lsp.foldexpr()"
  end
end

---@type vim.lsp.Config
local default_server_config = {
  ---@type vim.lsp.Client.Flags|{}
  flags = { debounce_text_changes = 150 },
  single_file_support = true,
  capabilities = vim.tbl_deep_extend(
    "force",
    lsp.protocol.make_client_capabilities(),
    {
      textDocument = {
        onTypeFormatting = { dynamicRegistration = lsp.on_type_formatting ~= nil },
      },
    }
  ),
  on_attach = original_on_attach,
}

lsp.config("*", default_server_config)
require("mason-lspconfig").setup({
  -- automatic_enable = { exclude = { "lua_ls" } },
  ensure_installed = nil,
})
lsp.enable({ "ruff" }, false)
lsp.inlay_hint.enable(true)

local signs = { Error = "󰅚", Warn = "", Hint = "󰌶", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
