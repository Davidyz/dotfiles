local ft_utils = require('filetype.utils')
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.py",
  callback = function()
    ft_utils.initTemplate("python", { "", "if __name__ == '__main__':", "    pass" }, function()
      return vim.g.editting_code_block ~= true
    end)
  end,
})
vim.api.nvim_create_autocmd("FileType", { pattern = "python", command = "setlocal ts=4 expandtab autoindent" })
