require("mason").setup()
require("mason-tool-installer").setup({
  auto_update = true,
  ensure_installed = {
    "black",
    "flake8",
    "clang-format",
    "shellcheck",
    "stylua",
    "clangd",
    "lua-language-server",
    "vim-language-server",
    "pyright",
    "clangd",
    "beautysh",
    "mypy",
    "jdtls",
  },
})
