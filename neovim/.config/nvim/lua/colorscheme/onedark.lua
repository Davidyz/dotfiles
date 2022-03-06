local onedark = require('onedark')

onedark.setup({
  style='darker'
})
onedark.load()

vim.api.nvim_command([[colorscheme onedark]])
