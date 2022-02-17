require("utils")

vim.api.nvim_set_option("filetype", "detect")
vim.opt.encoding = 'utf-8'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

if vim.bo.filetype ~= 'fstab' then
  vim.opt.expandtab = true
else
  vim.opt.expandtab = false
end

vim.opt.mouse = 'a'
vim.opt.swapfile = false

vim.opt.laststatus = 2

vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'

if vim.fn.has('unix') then
  vim.g.python3_host_prog = "/usr/bin/python3"
end

vim.o.cursorline = true
vim.o.compatible = false

if vim.fn.has('autocmd') then
  -- recover cursor location from history
  vim.api.nvim_command([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])
end

if not vim.fn.has('gui_running') and not vim.fn.has('termguicolors') then
  vim.api.nvim_set_option('t_Co', {256})
end

vim.opt.fillchars = "vert:"
vim.opt.foldlevel = 50

vim.api.nvim_command([[hi MatchParen gui=None guibg=Grey guifg=None]])
vim.opt.guifont = {'CaskaydiaCove Nerd Font Mono', 'Monospace'}
