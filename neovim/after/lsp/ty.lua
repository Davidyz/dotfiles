---@type vim.lsp.Config
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_dir = vim.fs.root(0, { ".git/", "pyproject.toml" }),
  handlers = {
    -- ty's inlayhint is not usable yet. disable it.
    [vim.lsp.protocol.Methods.textDocument_inlayHint] = function() end,
  },
}
