local lsp = vim.lsp
local api = vim.api

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
  on_attach = function(client, bufnr)
    if allow_for_formatting(client) then
      vim.bo[bufnr].formatexpr = "v:lua.lsp.formatexpr(#{timeout_ms:250})"
    else
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
    if not client:supports_method("textDocument/onTypeFormatting", bufnr) then
      lsp.on_type_formatting.enable(false, { client_id = client.id })
    end
  end,
}

api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = lsp.get_client_by_id(args.data.client_id)
    lsp.inlay_hint.enable(
      client and client:supports_method("textDocument/inlayHint", args.buf),
      { bufnr = args.buf }
    )
  end,
})

lsp.config("*", default_server_config)

local signs = { Error = "󰅚", Warn = "", Hint = "󰌶", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
