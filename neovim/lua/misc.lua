local api = vim.api
local fn = vim.fn

vim.opt.smartcase = true
vim.opt.encoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 0
vim.opt.hlsearch = false

vim.opt.mouse = "a"
vim.opt.swapfile = false

vim.opt.showmode = false
vim.o.clipboard = "unnamedplus"
if vim.env.SSH_CLIENT ~= nil then
  local function paste()
    return {
      fn.split(fn.getreg(""), "\n"),
      fn.getregtype(""),
    }
  end
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      -- wezterm doesn't support pasting.
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

if fn.has("unix") ~= 0 then
  if fn.executable("python3") then
    vim.g.python3_host_prog = "python3"
  elseif fn.executable("python") then
    vim.g.python3_host_prog = "python"
  elseif fn.executable("/usr/bin/python3") then
    vim.g.python3_host_prog = "/usr/bin/python3"
  elseif fn.executable("/usr/bin/python") then
    vim.g.python3_host_prog = "/usr/bin/python"
  end
elseif fn.has("win32") == 1 or fn.has("win64") == 1 then
  if fn.executable("py") == 1 then
    vim.g.python3_host_prog = "py"
  end
end

vim.o.cursorline = true
vim.o.cursorcolumn = true
api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
api.nvim_set_hl(0, "LazyBackdrop", { link = "Normal" })
api.nvim_set_hl(0, "Normal", { bg = "none", sp = "none" })
vim.o.compatible = false

if fn.has("gui_running") == 0 and fn.has("termguicolors") == 0 then
  api.nvim_set_option_value("t_Co", { 256 }, {})
end

vim.o.updatetime = 50
vim.o.laststatus = 3
vim.o.winborder = "none"

vim.o.viewoptions = "folds,cursor"

vim.o.switchbuf = "useopen,usetab,newtab"
-- local ok, extui = pcall(require, "vim._extui")
-- if ok then
--   extui.enable({})
-- end

api.nvim_create_autocmd({ "FileType" }, {
  -- avoid auto-commenting when hitting enter
  command = "set formatoptions-=ro",
})

vim.opt.foldmethod = "expr"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

api.nvim_create_augroup("restore_view_group", { clear = true })

api.nvim_create_autocmd("BufWinLeave", {
  group = "restore_view_group",
  callback = function()
    pcall(function()
      if vim.bo.buftype == "" and vim.fn.bufname() ~= "" then
        vim.cmd("mkview")
      end
    end)
  end,
})

-- Autocommand to load the view when entering a buffer in a window
api.nvim_create_autocmd("BufWinEnter", {
  group = "restore_view_group",
  callback = function()
    pcall(function()
      if vim.bo.buftype == "" and vim.fn.bufname() ~= "" then
        vim.cmd("loadview")
      end
    end)
  end,
})
