---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      format = {
        enable = false,
        defaultConfig = {
          indent_style = "space",
          indent_size = 2,
          quote_style = "double",
        },
      },
      completion = {
        callSnippet = "Replace",
        displayContext = 5,
        keywordSnippet = "Replace",
      },
      workspace = {
        useGitIgnore = true,
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
      diagnostics = { workspaceEvent = "OnSave" },
      hint = { enable = true, setType = true },
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.foldingRangeProvider = nil
    client.server_capabilities.documentOnTypeFormattingProvider = nil
  end,
}
