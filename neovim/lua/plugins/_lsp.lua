local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

vim.opt.completeopt = { "menu", "menuone", "popup" }

---@param client vim.lsp.Client
---@return boolean
local function allow_for_formatting(client)
  local blacklisted_formatter = { "basedpyright", "emmylua_ls" }
  if vim.fn.executable("black") == 1 then
    vim.list_extend(blacklisted_formatter, { "ruff", "ruff_lsp" })
  end
  return not vim.list_contains(blacklisted_formatter, client.name)
end

local original_on_attach = function(client, bufnr)
  if allow_for_formatting(client) then
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})"
  end
  if client:supports_method("textDocument/formatting") then
    -- format on save
    vim.api.nvim_clear_autocmds({ buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        if vim.g.format_on_save == false then
          return
        end
        vim.lsp.buf.format({
          filter = allow_for_formatting,
          async = true,
        })
      end,
    })
  end
  if client.server_capabilities.inlayHintProvider and vim.bo.filetype ~= "tex" then
    vim.g.inlay_hints_visible = true
    ---@diagnostic disable-next-line: unused-local
    local status, err = pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    if not status then
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
  end
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
end

local default_server_config = {
  flags = { debounce_text_changes = 150 },
  single_file_support = true,
  capabilities = lsp_defaults.capabilities,
  on_attach = original_on_attach,
}
vim.lsp.config("*", default_server_config)
-- vim.lsp.config("ty", default_server_config)
-- vim.lsp.config("ty", {
--   cmd = { "ty", "server" },
--   filetypes = { "python" },
--   root_dir = vim.fs.root(0, { ".git/", "pyproject.toml" }),
-- })
-- vim.lsp.enable("ty")
require("mason-lspconfig").setup({
  -- automatic_enable = { exclude = { "lua_ls" } },
  -- automatic_enable = { exclude = { "basedpyright" } },
  ensure_installed = nil,
})

local signs = { Error = "󰅚", Warn = "", Hint = "󰌶", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
