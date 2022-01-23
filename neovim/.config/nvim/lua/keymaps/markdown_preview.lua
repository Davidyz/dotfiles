require('utils')

for _, ft in ipairs(TEXT) do
  vim.api.nvim_command([[autocmd FileType ]] .. ft .. [[ nnoremap mp :MarkdownPreviewToggle<CR>]])
end
