---@type vim.lsp.Config
return {
  capabilities = {
    textDocument = {
      onTypeFormatting = { dynamicRegistration = true },
      formatting = { dynamicRegistration = false },
      rangeFormatting = { dynamicRegistration = false },
    },
  },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        inlayHints = {
          callArgumentNames = "all",
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
          genericTypes = true,
          useTypingExtensions = true,
        },
        autoFormatStrings = true,
        autoImportCompletions = true,
      },
      linting = { enabled = false },
      disableOrganizeImports = true,
    },
  },
  on_attach = function(client, bufnr)
    -- the following are handled by `ty`
    if not vim.tbl_isempty(vim.lsp.get_clients({ name = "ty" })) then
      client.server_capabilities.definitionProvider = false
      client.server_capabilities.declarationProvider = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.completionProvider = nil
    end
  end,
}
