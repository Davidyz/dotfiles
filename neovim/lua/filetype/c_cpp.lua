local ft_utils = require("filetype.utils")
local types = { ["c"] = "*.c", ["cpp"] = "*.cpp", arduino = "*.ino" }

Clang_Format = ft_utils.format("clang-format")

for type, suffix in pairs(types) do
  vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = type, command = ":setlocal autoindent ts=2 sts=2 shiftwidth=0" }
  )
  -- vim.api.nvim_create_autocmd("BufWritePre", {
  -- pattern = suffix,
  -- callback = ft_utils.format("clang-format", ""),
  -- })
end
