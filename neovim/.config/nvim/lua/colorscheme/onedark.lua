local onedark = require("onedarkpro")

onedark.setup({
  theme = "onedark",
  styles = {
    strings = "NONE", -- Style that is applied to strings
    comments = "NONE", -- Style that is applied to comments
    keywords = "NONE", -- Style that is applied to keywords
    functions = "NONE", -- Style that is applied to functions
    variables = "NONE", -- Style that is applied to variables
    virtual_text = "NONE",
  },
  options = {
    bold = false, -- Use the themes opinionated bold styles?
    italic = false, -- Use the themes opinionated italic styles?
    underline = false, -- Use the themes opinionated underline styles?
    undercurl = false, -- Use the themes opinionated undercurl styles?
    cursorline = false, -- Use cursorline highlighting?
    transparency = false, -- Use a transparent background?
    terminal_colors = false, -- Use the theme's colors for Neovim's :terminal?
    window_unfocussed_color = true,
  },
})
onedark.load()
