local ft_utils = require("filetype.utils")

vim.api.nvim_create_autocmd("FileType", { pattern = "haskell", command = "setlocal ts=4 autoindent sts=4" })
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.hs", callback = ft_utils.format("fourmolu") })
