local ft_utils = require("filetype.utils")
local packages = { "rope", "pyright" }
local co = coroutine.create(function(dep)
  if vim.fn.has("unix") ~= 0 and os.execute('python -c "import ' .. dep .. '" 2> /dev/null') ~= 0 then
    os.execute("python -m pip install " .. dep .. " > /dev/null")
  end
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    for _, dep in ipairs(packages) do
      coroutine.resume(co, dep)
    end
  end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.py",
  callback = function()
    ft_utils.initTemplate("python", { "", "if __name__ == '__main__':", "    pass" }, function()
      return vim.g.editting_code_block ~= true
    end)
  end,
})
vim.api.nvim_create_autocmd("FileType", { pattern = "python", command = "setlocal ts=4 expandtab autoindent" })
