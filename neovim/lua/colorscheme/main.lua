local utils = require("_utils")

if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
end
vim.opt.background = "dark"

local onedark = require("onedarkpro")

onedark.setup({
  theme = "onedark",
  styles = {
    strings = "NONE",
    comments = "italic",
    keywords = "bold",
    functions = "NONE",
    variables = "NONE",
    virtual_text = "NONE",
  },
  options = {
    bold = true,
    italic = true,
    underline = true,
    undercurl = true,
    cursorline = true,
    transparency = true,
    terminal_colors = true,
    highlight_inactive_windows = true,
  },
  plugins = { treesitter = true, nvim_lsp = true, all = true },
})
onedark.load()
