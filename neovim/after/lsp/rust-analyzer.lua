---@type vim.lsp.Config
return {
  workspace_required = false,
  settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        closureCaptureHints = {
          enable = true,
        },
        closureReturnTypeHints = { enable = "always" },
      },
    },
  },
}
