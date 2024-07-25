return function()
  local null_ls = require("null-ls")
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  local mason_config = {
    border = "double",
    sources = {
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.code_actions.refactoring,
    },
  }
  require("mason-registry").get_package("black"):uninstall()
  if vim.fn.executable("black") == 1 then
    mason_config.sources =
      vim.list_extend(mason_config.sources, { null_ls.builtins.formatting.black })
  end
  null_ls.setup(mason_config)
end
