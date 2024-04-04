local utils = require("_utils")
local job = require("plenary.job")

vim.opt.smartcase = true
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
if vim.fn.has("nvim-0.7") ~= 0 then
  vim.o.laststatus = 3
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.b.editting_vim_config = (
      vim.fn.expand("%:p"):gmatch("%.*/.config/nvim/%.*")() ~= nil
    )
  end,
})

for command, package in pairs({ nvr = "neovim-remote", ipython = "ipython" }) do
  if type(command) == "number" or vim.fn.executable(command) == 0 then
    job
      :new({
        command = vim.g.python3_host_prog,
        args = { "-m", "pip", "install", package },
        on_exit = function()
          print(package .. " has been installed.")
        end,
      })
      :start()
  end
end

vim.fn.setenv("NVIM_LISTEN_ADDRESS", vim.v.servername)

local external_deps = { "rg", "python3", "node", "npm" }
local missing_packages = ""
for _, cmd in ipairs(external_deps) do
  if vim.fn.executable(cmd) == 0 then
    if missing_packages == "" then
      missing_packages = cmd
    else
      missing_packages = missing_packages .. " " .. cmd
    end
  end
end
if missing_packages ~= "" then
  print("Missing external command(s): " .. missing_packages)
end

local fold_group = vim.api.nvim_create_augroup("AutoSaveFold", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype == "" then
      return
    end
    local file_name = vim.fn.expand("%")
    if file_name ~= "" and vim.fn.filereadable(file_name) == 1 then
      vim.cmd("set viewoptions-=curdir")
      vim.cmd("silent! loadview")
    end
  end,
  buffer = 0,
  once = true,
  group = fold_group,
})
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.bo.filetype == "" then
      return
    end
    local file_name = vim.fn.expand("%")
    if file_name ~= "" and vim.fn.filereadable(file_name) == 1 then
      vim.cmd("set viewoptions-=curdir")
      vim.cmd("silent! mkview")
    end
  end,
  buffer = 0,
  once = true,
  group = fold_group,
})
