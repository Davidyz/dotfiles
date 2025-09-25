---@type vim.lsp.Config
return {
  init_options = { settings = { configurationPreference = "filesystemFirst" } },
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
  end,
}
