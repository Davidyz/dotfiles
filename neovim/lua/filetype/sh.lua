local languages = { "sh", "bash" }

for _, lang in ipairs(languages) do
  vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = lang, command = "setlocal autoindent sts=2 ts=2 sw=2" }
  )
end
