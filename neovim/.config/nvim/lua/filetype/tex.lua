vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  pattern = "*.tex",
  callback = function()
    if vim.fn.executable("texcount") ~= 0 and vim.bo.filetype == "tex" then
      vim.b.latex_wc = string.match(vim.fn.system("texcount -inc -sum -1 " .. vim.fn.expand("%")), "%d+")
    end
  end,
})
