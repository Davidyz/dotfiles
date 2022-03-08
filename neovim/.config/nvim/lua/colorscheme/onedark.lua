local onedark = require("onedark")

onedark.setup({
  style = "warmer",
})
onedark.load()

vim.api.nvim_command([[colorscheme onedark]])
