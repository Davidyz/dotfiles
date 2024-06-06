vim.opt.smartcase = true
vim.opt.encoding = "utf-8"
-- vim.opt.shadafile = "~/.local/share/nvim/shada/main.shada"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 0

vim.opt.mouse = "a"
vim.opt.swapfile = false

vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"

if vim.fn.has("unix") ~= 0 then
  if vim.fn.executable("python3") then
    vim.g.python3_host_prog = "python3"
  elseif vim.fn.executable("python") then
    vim.g.python3_host_prog = "python"
  elseif vim.fn.executable("/usr/bin/python3") then
    vim.g.python3_host_prog = "/usr/bin/python3"
  elseif vim.fn.executable("/usr/bin/python") then
    vim.g.python3_host_prog = "/usr/bin/python"
  end
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  if vim.fn.executable("py") == 1 then
    vim.g.python3_host_prog = "py"
  end
end

vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
vim.api.nvim_set_hl(0, "Normal", { bg = "none", sp = "none" })
vim.o.compatible = false

-- recover cursor location from history
vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "*" },
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.api.nvim_command("normal! g'\"")
    end
  end,
})

if vim.fn.has("gui_running") == 0 and vim.fn.has("termguicolors") == 0 then
  vim.api.nvim_set_option_value("t_Co", { 256 }, {})
end

vim.opt.foldlevel = 50

vim.api.nvim_set_hl(0, "MatchParen", { link = "TermCursorNC" })

vim.opt.guifont = { "CaskaydiaCove Nerd Font Mono", "Monospace" }
vim.o.updatetime = 50
vim.o.laststatus = 3

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.b.editting_vim_config = (
      vim.fn.expand("%:p"):gmatch("%.*/.config/nvim/%.*")() ~= nil
    )
  end,
})

vim.fn.setenv("NVIM_LISTEN_ADDRESS", vim.v.servername)
