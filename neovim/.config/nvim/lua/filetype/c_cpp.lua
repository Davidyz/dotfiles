local types = {'c', 'cpp'}

function Clang_Format()
  if vim.fn.executable('clang-format') then
    vim.api.nvim_command([[:silent! mkview]])
    vim.api.nvim_command([[:%!clang-format]])
    vim.api.nvim_command([[:silent! loadview]])
  end
end

for _, type in ipairs(types) do
  vim.api.nvim_command([[autocmd FileType ]] .. type .. [[ setlocal autoindent ts=2 sts=2 shiftwidth=0 equalprg=clang-format]])
  if vim.fn.executable('clang-format') then
    vim.api.nvim_command([[autocmd FileType ]] .. type .. [[ autocmd BufWritePre * call v:lua.Clang_Format()]])
  end
end
