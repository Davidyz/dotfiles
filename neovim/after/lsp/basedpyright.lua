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
}
