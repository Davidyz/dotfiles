local cmd

if vim.fn.executable("delance-langserver") == 1 then
  cmd = { "delance-langserver", "--stdio" }
end

---@type vim.lsp.Config
return {
  cmd = cmd,
  capabilities = {
    textDocument = {
      onTypeFormatting = { dynamicRegistration = true },
      formatting = { dynamicRegistration = false },
      rangeFormatting = { dynamicRegistration = false },
    },
  },
  settings = {
    python = {
      analysis = {
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        },
        autoFormatStrings = true,
      },
    },
  },
}
