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
      vim.fn.split(vim.fn.getreg(""), "\n"),
      vim.fn.getregtype(""),
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
vim.api.nvim_set_hl(0, "LazyBackdrop", { link = "Normal" })
vim.api.nvim_set_hl(0, "Normal", { bg = "none", sp = "none" })
vim.o.compatible = false

if vim.fn.has("gui_running") == 0 and vim.fn.has("termguicolors") == 0 then
  vim.api.nvim_set_option_value("t_Co", { 256 }, {})
end

vim.o.updatetime = 50
vim.o.laststatus = 3
vim.o.winborder = "none"

vim.o.viewoptions = "folds,cursor"
local group = vim.api.nvim_create_augroup("ViewSaver", { clear = true })

vim.api.nvim_create_autocmd("BufUnload", {
  group = group,
  callback = function(args)
    local uri = vim.uri_from_bufnr(0)
    local path = vim.uri_to_fname(uri)
    local stat = vim.uv.fs_stat(path)
    if stat ~= nil and stat.type == "file" then
      vim.cmd("mkview")
    end
  end,
})
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { group = group, command = "silent! loadview" }
)
vim.o.switchbuf = "useopen,usetab,newtab"
-- local ok, extui = pcall(require, "vim._extui")
-- if ok then
--   extui.enable({})
-- end

vim.api.nvim_create_autocmd({ "FileType" }, {
  -- avoid auto-commenting when hitting enter
  command = "set formatoptions-=ro",
})
