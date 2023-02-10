local utils = require("_utils")
local job = require("plenary.job")

vim.api.nvim_set_option("filetype", "detect")
vim.opt.encoding = "utf-8"
-- vim.opt.shadafile = "~/.local/share/nvim/shada/main.shada"

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
  if vim.fn.executable("python3") then
    vim.g.python3_host_prog = "python3"
  elseif vim.fn.executable("python") then
    vim.g.python3_host_prog = "python"
  elseif vim.fn.executable("/usr/bin/python3") then
    vim.g.python3_host_prog = "/usr/bin/python3"
  elseif vim.fn.executable("/usr/bin/python") then
    vim.g.python3_host_prog = "/usr/bin/python"
  end
elseif (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and vim.fn.executable("py") == 1 then
  vim.g.python3_host_prog = "py"
end

vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.api.nvim_set_hl(0, "CursorColumn", vim.api.nvim_get_hl_by_name("CursorLine", {}))
vim.o.compatible = false

-- recover cursor location from history
vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "*" },
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.api.nvim_exec("normal! g'\"", false)
    end
  end,
})

if vim.fn.has("gui_running") == 0 and vim.fn.has("termguicolors") == 0 then
  vim.api.nvim_set_option("t_Co", { 256 })
end

vim.opt.foldlevel = 50

vim.api.nvim_set_hl(0, "MatchParen", vim.api.nvim_get_hl_by_name("TermCursorNC", {}))

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

for command, package in pairs({ nvr = "neovim-remote", black = "black", isort = "isort", ipython = "ipython" }) do
  if type(command) == "number" or vim.fn.executable(command) == 0 then
    job
      :new({
        command = "python",
        args = { "-m", "pip", "install", package },
        on_exit = function()
          print(package .. " has been installed.")
        end,
      })
      :start()
  end
end

if vim.fn.executable("stylua") == 0 and vim.fn.executable("luarocks") > 0 then
  job
    :new({
      command = "luarocks",
      args = { "install", "--local", "stylua" },
      on_exit = function()
        print("stylua has been installed.")
      end,
    })
    :start()
end

vim.fn.setenv("NVIM_LISTEN_ADDRESS", vim.v.servername)
