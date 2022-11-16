vim.g.black_linelength = 79

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- pattern = "*.py",
-- callback = function()
-- if vim.fn.exists(":Black") then
-- vim.api.nvim_command("Black")
-- end
-- end,
-- })
