if
  vim.fn.filereadable(vim.fn.expand("~/.arduino15/arduino-cli.yaml")) == 0
  and vim.fn.executable("arduino-cli")
then
  vim.fn.system("arduino-cli config init")
end
return {
  cmd = {
    "arduino-language-server",
    "-cli",
    vim.fn.exepath("arduino-cli"),
    "-clangd",
    vim.fn.exepath("clangd"),
    "-cli-config",
    "~/.arduino15/arduino-cli.yaml",
  },
  capabilities = { workspace = { semanticTokens = nil } },
}
