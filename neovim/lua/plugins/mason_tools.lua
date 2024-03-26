local plugin_utils = require("plugins.utils")
require("mason-tool-installer").setup({
  auto_update = true,
  ensure_installed = plugin_utils.mason_packages,
})
