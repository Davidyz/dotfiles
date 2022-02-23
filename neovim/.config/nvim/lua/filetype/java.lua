vim.api.nvim_command([[autocmd BufNewFile *.java exe "normal Ipublic class " . expand('%:t:r') . "{\n}\<Esc>1G"]])
vim.api.nvim_command([[autocmd FileType java setlocal autoindent shiftwidth=0 ts=2 sts=2]])
if vim.fn.executable('google-java-format') then
  vim.api.nvim_command([[autocmd FileType java autocmd BufWritePre * :%!google-java-format -]])
end
