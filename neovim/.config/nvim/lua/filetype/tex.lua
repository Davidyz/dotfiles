local tex_errors = function()
  local diags = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  if not diags then
    return false
  end
  return true
end

local job = require("plenary.job")
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
    if not tex_errors() and vim.fn.executable("pdflatex") then
      job
        :new({
          command = "pdflatex",
          args = { vim.fn.expand("%:p") },
          on_exit = function()
            print("Latex build job finished.")
          end,
        })
        :start()
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.tex",
  callback = function()
    vim.opt.textwidth = 88
    vim.wo.wrap = true
    vim.wo.linebreak = true
  end,
})
