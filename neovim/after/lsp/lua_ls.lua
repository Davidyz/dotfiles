---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
        displayContext = 5,
        keywordSnippet = "Replace",
      },
      diagnostics = { workspaceEvent = "OnSave", unusedLocalExclude = { "_*" } },
      format = {
        enable = false,
        defaultConfig = {
          indent_style = "space",
          indent_size = 2,
          quote_style = "double",
        },
      },
      hint = { enable = true, setType = true },
      hover = { expandAlias = false },
      language = { fixIndent = false },

      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },

      type = { inferParamType = true },
      typeFormat = { enable = false },
      workspace = {
        useGitIgnore = true,
        checkThirdParty = false,
      },
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.documentOnTypeFormattingProvider = nil
    -- vim.schedule(function()
    --   local winnr = vim.fn.bufwinid(bufnr)
    --   vim.wo[winnr].foldlevel = 999
    -- end)
  end,
}
