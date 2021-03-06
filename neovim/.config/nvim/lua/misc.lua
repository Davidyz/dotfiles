local utils = require("utils")
local job = require("plenary.job")

vim.api.nvim_set_option("filetype", "detect")
vim.opt.encoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

if vim.bo.filetype ~= "fstab" then
  vim.opt.expandtab = true
else
  vim.opt.expandtab = false
end

vim.opt.mouse = "a"
vim.opt.swapfile = false

vim.opt.laststatus = 2

vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"

if vim.fn.has("unix") ~= 0 then
  if vim.fn.executable("/usr/bin/python3") then
    vim.g.python3_host_prog = "/usr/bin/python3"
  elseif vim.fn.executable("python3") then
    vim.g.python3_host_prog = "python3"
  elseif vim.fn.executable("/usr/bin/python") then
    vim.g.python3_host_prog = "/usr/bin/python"
  elseif vim.fn.executable("python") then
    vim.g.python3_host_prog = "python"
  end
elseif (vim.fn.has("win32") or vim.fn.has("win64")) and vim.fn.executable("py") then
  vim.g.python3_host_prog = "py"
end

vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.api.nvim_command([[
hi clear CursorColumn
hi link CursorColumn CursorLine
]])
vim.o.compatible = false

-- recover cursor location from history
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { pattern = "*", command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]] }
)

if vim.fn.has("gui_running") == 0 and vim.fn.has("termguicolors") == 0 then
  vim.api.nvim_set_option("t_Co", { 256 })
end

vim.opt.foldlevel = 50

vim.api.nvim_command([[hi MatchParen gui=None guibg=Grey guifg=None]])
vim.opt.guifont = { "CaskaydiaCove Nerd Font Mono", "Monospace" }
vim.api.nvim_set_option("updatetime", 50)
if vim.fn.has("nvim-0.7") ~= 0 then
  vim.api.nvim_set_option("laststatus", 3)
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.b.editting_vim_config = (vim.fn.expand("%:p"):gmatch("%.*/.config/nvim/%.*")() ~= nil)
  end,
})

if not vim.fn.executable("nvr") then
  job
    :new({
      command = "python",
      args = { "-m", "pip", "install", "neovim-remote" },
      on_exit = function()
        print("neovim-remote has been installed.")
      end,
    })
    :start()
end
