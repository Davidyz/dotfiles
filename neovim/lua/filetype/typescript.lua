local languages = { "javascript", "typescript" }

for _, lang in ipairs(languages) do
  vim.api.nvim_create_autocmd("FileType", { pattern = lang, command = "setlocal ts=2 autoindent shiftwidth=0" })
end
