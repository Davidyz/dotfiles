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
        autoFormatStrings = true,
        autoImportCompletions = true,
        inlayHints = {
          callArgumentNames = "all",
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
          genericTypes = true,
          useTypingExtensions = true,
          callArgumentNamesMatching = true,
        },
        typeCheckingMode = "standard",
        exclude = { "build/**" },
      },
      linting = { enabled = false },
      disableOrganizeImports = true,
    },
  },
}
