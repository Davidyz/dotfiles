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
    window_unfocused_color = true,
  },
  plugins = { treesitter = true },
})
onedark.load()
