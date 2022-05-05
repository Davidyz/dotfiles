vim.g.black_linelength = 79

if vim.fn.exists(":Black") ~= 0 then
  vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.py", command = "Black" })
end
