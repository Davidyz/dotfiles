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
          callArgumentNamesMatching = true,
        },
        autoFormatStrings = true,
        autoImportCompletions = true,
      },
      linting = { enabled = false },
      disableOrganizeImports = true,
    },
  },
  on_attach = function(client, bufnr)
    -- the following are handled by `ty` or `pyrefly`
    if
      vim.iter({ "ty", "pyrefly" }):any(function(name)
        return vim.tbl_isempty(vim.lsp.get_clients({ name = name }))
      end)
    then
      client.server_capabilities.definitionProvider = false
      client.server_capabilities.declarationProvider = false
      client.server_capabilities.referencesProvider = false
      client.server_capabilities.documentFormattingProvider = false
      -- client.server_capabilities.inlayHintProvider = false
    end
  end,
}
