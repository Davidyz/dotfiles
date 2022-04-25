local onedark = require("onedarkpro")

onedark.setup({
  theme = function()
    if vim.o.background == "dark" then
      return "onedark"
    else
      return "onelight"
    end
  end,
  options = {
    cursorline = true,
  },
  styles = { keywords = "italic" },
})
onedark.load()
