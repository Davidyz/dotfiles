require("filetype.utils")
local types = { "c", "cpp" }

Clang_Format = format("clang-format")

for _, type in ipairs(types) do
  if vim.fn.executable("clang-format") then
    vim.api.nvim_command(
      [[autocmd FileType ]] .. type .. [[ setlocal autoindent ts=2 sts=2 shiftwidth=0 equalprg=clang-format]]
    )
    vim.api.nvim_command(
      [[autocmd FileType ]] .. type .. [[ autocmd BufWritePre * call v:lua.format('clang-format')()]]
    )
  end
end
