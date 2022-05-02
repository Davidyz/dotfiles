local onedark = require("onedarkpro")

onedark.setup({
  theme = "onedark",
  styles = {
    strings = "NONE",
    comments = "NONE",
    keywords = "italic",
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
    window_unfocussed_color = true,
  },
  plugins = { treesitter = true },
})
onedark.load()
