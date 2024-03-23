local utils = require("_utils")

local job = require("plenary.job")
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  pattern = "*.tex",
  callback = function()
    if vim.fn.executable("texcount") ~= 0 and vim.bo.filetype == "tex" then
      vim.b.latex_wc = string.match(
        vim.fn.system("texcount -inc -sum -1 " .. vim.fn.expand("%")),
        "%d+"
      )
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.tex",
  callback = function()
    vim.opt.textwidth = 88
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.bo.shiftwidth = 4
  end,
})

if
  utils.all({ "xargs", "pgrep", "zathura" }, function(arg)
    return vim.fn.executable(arg) == 1
  end)
then
  vim.api.nvim_create_autocmd({ "BufLeave", "VimLeave" }, {
    pattern = "*.tex",
    callback = function()
      local tex_buffer_open = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if
          --vim.api.nvim_buf_is_loaded(buf)
          --and string.match(vim.api.nvim_buf_get_name(buf), "%.tex$")
          string.match(vim.api.nvim_buf_get_name(buf), "%.tex$")
        then
          tex_buffer_open = true
          break
        end
      end

      if not tex_buffer_open then
        local cmd = "pgrep zathura | xargs kill -9"
        vim.fn.system(cmd)
      end
    end,
  })
end
