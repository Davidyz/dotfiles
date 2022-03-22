vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.py",
  callback = function()
    vim.fn.append(1, "")
    vim.fn.append(2, [[if __name__ == '__main__':]])
    vim.fn.append(3, [[    pass]])
    vim.fn.cursor(1, 0)
  end,
})
vim.api.nvim_create_autocmd("FileType", { pattern = "python", command = "setlocal ts=4 expandtab autoindent" })
