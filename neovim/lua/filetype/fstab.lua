vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fstab" },
  callback = function()
    vim.bo.expandtab = false
  end,
})
