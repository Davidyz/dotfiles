local languages = {'sh', 'bash'}

for _, lang in ipairs(languages) do
  vim.api.nvim_command([[autocmd FileType ]] .. lang .. [[ setlocal autoindent sts=2 ts=2]])
end
