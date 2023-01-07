local coc_diagnostics = function()
  local data = vim.b.coc_diagnostic_info
  if data then
    return data.error, data.warning, data.information, data.hint
  else
    return 0, 0, 0, 0
  end
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  pattern = "*.tex",
  callback = function()
    if vim.fn.executable("texcount") ~= 0 and vim.bo.filetype == "tex" then
      vim.b.latex_wc = string.match(vim.fn.system("texcount -inc -sum -1 " .. vim.fn.expand("%")), "%d+")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = "*.tex",
  callback = function()
    local e, w, i, h = coc_diagnostics()
    if e == 0 and vim.fn["CocActionAsync"] ~= nil then
      vim.fn["CocActionAsync"]("runCommand", "latex.Build")
    end
  end,
})
