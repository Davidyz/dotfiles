require("utils")

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
  vim.g.python3_host_prog = "/usr/bin/python3"
elseif vim.fn.has("win32") or vim.fn.has("win64") then
  local count
  vim.g.python3_host_prog, count = string.gsub(vim.fn.which("python3"), "\n", "")
end

vim.o.cursorline = true
vim.o.compatible = false

-- recover cursor location from history
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { pattern = "*", command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]] }
)

if vim.fn.has("gui_running") == 0 and vim.fn.has("termguicolors") == 0 then
  vim.api.nvim_set_option("t_Co", { 256 })
end

vim.opt.fillchars = "vert:"
vim.opt.foldlevel = 50

vim.api.nvim_command([[hi MatchParen gui=None guibg=Grey guifg=None]])
vim.opt.guifont = { "CaskaydiaCove Nerd Font Mono", "Monospace" }
