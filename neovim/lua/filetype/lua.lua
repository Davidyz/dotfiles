vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.bo.ts = 2
    vim.bo.sts = 2
    vim.bo.expandtab = true
    vim.bo.autoindent = true
  end,
})
