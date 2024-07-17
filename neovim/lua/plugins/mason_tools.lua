local null_ls = require("null-ls")
local plugin_utils = require("plugins.utils")
require("mason-null-ls").setup({
  automatic_installation = true,
  handlers = {
    shfmt = function()
      null_ls.register(null_ls.builtins.formatting.shfmt.with({
        filetypes = { "sh", "bash", "zsh" },
        extra_args = { "-i", vim.bo.sts },
      }))
    end,
  },
  ensure_installed = plugin_utils.mason_packages,
})
require("mason-tool-installer").setup({
  auto_update = true,
  ensure_installed = plugin_utils.mason_packages,
})
