vim.opt.completeopt = { "menu", "menuone", "popup" }
vim.lsp.on_type_formatting = vim.lsp.on_type_formatting
  or require("plugins.lsp-handlers.on_type_formatting")
vim.lsp.on_type_formatting.enable(true)

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
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})"
  end
  if
    client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting)
    and allow_for_formatting(client)
  then
    -- format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup(
        string.format("LspFormatBuf%d", bufnr),
        { clear = true }
      ),
      buffer = bufnr,
      callback = function()
        if vim.g.format_on_save == false then
          return
        end
        vim.lsp.buf.format({
          filter = allow_for_formatting,
        })
      end,
    })
  end
  if
    not client:supports_method(
      vim.lsp.protocol.Methods.textDocument_onTypeFormatting,
      bufnr
    )
  then
    vim.lsp.on_type_formatting.enable(false, { client_id = client.id })
  end
  if
    client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr)
    and vim.bo.filetype ~= "tex"
  then
    vim.g.inlay_hints_visible = true
    ---@diagnostic disable-next-line: unused-local
    local status, err = pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    if not status then
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
  end
  if
    client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol, bufnr)
  then
    require("nvim-navic").attach(client, bufnr)
  end
end

---@type vim.lsp.Config
local default_server_config = {
  ---@type vim.lsp.Client.Flags|{}
  flags = { debounce_text_changes = 150 },
  single_file_support = true,
  capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    {
      textDocument = {
        onTypeFormatting = { dynamicRegistration = vim.lsp.on_type_formatting ~= nil },
      },
    }
  ),
  on_attach = original_on_attach,
}

vim.lsp.config("*", default_server_config)
require("mason-lspconfig").setup({
  -- automatic_enable = { exclude = { "lua_ls" } },
  ensure_installed = nil,
})

local signs = { Error = "󰅚", Warn = "", Hint = "󰌶", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
