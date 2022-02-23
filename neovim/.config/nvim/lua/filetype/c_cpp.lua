local types = {'c', 'cpp'}
for _, type in ipairs(types) do
  vim.api.nvim_command([[autocmd FileType ]] .. type .. [[ setlocal autoindent ts=2 sts=2 shiftwidth=0 equalprg=clang-format]])
  if vim.fn.executable('clang-format') then
    vim.api.nvim_command([[autocmd FileType ]] .. type .. [[ autocmd BufWritePre * :%!clang-format]])
  end
end
