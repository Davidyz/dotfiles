vim.g.jupytext_enable = 1
vim.g.jupytext_fmt = "py:light"
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.ipynb",
  callback = function()
    vim.bo.filetype = "ipynb"
  end,
})
