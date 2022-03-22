vim.api.nvim_create_autocmd("FileType", { pattern = "vim", command = "setlocal ts=2 sts=2 autoindent shiftwidth=2" })
