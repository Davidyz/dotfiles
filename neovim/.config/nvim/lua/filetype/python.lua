local ft_utils = require("filetype.utils")
local packages = { "rope", "pyright", "debugpy", "isort" }
local job = require("plenary.job")

vim.api.nvim_create_autocmd("BufEnter", {
  -- install necessary packages for development and refactoring.
  pattern = "*.py",
  callback = function()
    for _, dep in ipairs(packages) do
      if
        vim.fn.has("unix") ~= 0
        and os.execute('python -c "import ' .. dep .. '" 2> /dev/null') ~= 0
      then
        job
          :new({
            command = "python",
            args = { "-m", "pip", "install", dep },
            on_exit = function()
              print(dep .. " has been installed.")
            end,
          })
          :start()
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.py",
  callback = function()
    ft_utils.initTemplate(
      "python",
      { "", "if __name__ == '__main__':", "    pass" },
      function()
        return vim.g.editting_code_block ~= true
      end
    )
  end,
})
vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "python", command = "setlocal ts=4 expandtab autoindent" }
)
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.ipynb",
  callback = function()
    vim.bo.filetype = "ipynb,python"
  end,
})
