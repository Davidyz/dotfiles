local utils = require("_utils")

if vim.loader ~= nil and type(vim.loader.enable) == "function" then
  vim.loader.enable()
end

if vim.fn.has("win32") == 1 then
  local powershell_options = {
    shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("misc")

---Recursively find all specs in `this_dir`.
---@param base_dir string
---@return LazySpecImport[]
local function find_specs(base_dir)
  local this_dir = vim.fs.dirname(debug.getinfo(1, "S").short_src)
  local specs = vim
    .iter(vim.fs.dir(vim.fs.joinpath(this_dir, "lua", base_dir), { depth = math.huge }))
    :filter(function(_, type)
      return type == "directory"
    end)
    :map(function(p, _)
      return {
        import = string.format("%s.%s", base_dir, p:gsub("%.lua$", ""):gsub("/", ".")),
      }
    end)
    :totable()
  table.insert(specs, { import = base_dir })
  return specs
end

require("lazy").setup({
  spec = find_specs("plugin_specs"),
  defaults = { lazy = true },
  dev = { fallback = true },
  install = { colorscheme = { "catppuccin-mocha" } },
  profiling = { loader = true, require = true },
  ui = {
    border = "solid",
    backdrop = 100,
  },
})

local items = {
  "keymaps.main",
  "filetype.main",
}
utils.tryRequire(items, 2)
require("lsp")
if vim.g.neovide then
  pcall(require, "neovide")
end
