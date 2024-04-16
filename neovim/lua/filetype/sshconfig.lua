vim.api.nvim_create_autocmd("FileType", {
  pattern = "sshconfig",
  callback = function()
    vim.bo.expandtab = true -- Use spaces instead of tabs
    vim.bo.tabstop = 2 -- A tab is two spaces
    vim.bo.shiftwidth = 2 -- Indent also 2 spaces
    vim.bo.softtabstop = 2 -- Soft tab stop at 2 spaces
  end,
})
