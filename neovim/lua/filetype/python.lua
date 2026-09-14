vim.api.nvim_create_autocmd("FileType", { pattern = "python", command = "setlocal ts=4 sts=4 expandtab autoindent" })
