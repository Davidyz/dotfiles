local has_black = vim.fn.executable("black") == 1
return {
  capabilities = {
    textDocument = {
      formatting = { dynamicRegistration = not has_black },
      rangeFormatting = { dynamicRegistration = not has_black },
    },
  },
}
