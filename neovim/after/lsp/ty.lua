---@type vim.lsp.Config
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_dir = vim.fs.root(0, { ".git/", "pyproject.toml" }),
  handlers = {
    -- disable some functionalities that ty doesn't do well at.
    -- [vim.lsp.protocol.Methods.textDocument_inlayHint] = function() end,
    -- [vim.lsp.protocol.Methods.textDocument_signatureHelp] = function() end,
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.inlayHintProvider = false
    -- client.server_capabilities.signatureHelpProvider = nil
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.completionProvider = nil

    -- client.server_capabilities.definitionProvider = false
    -- client.server_capabilities.typeDefinitionProvider = false
    -- client.server_capabilities.declarationProvider = false
    -- client.server_capabilities.referencesProvider = false
  end,
}
