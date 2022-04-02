vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.java",
  callback = function()
    vim.fn.setline(1, [[public class ]] .. vim.fn.expand("%:t:r") .. "{")
    vim.fn.setline(2, [[]])
    vim.fn.setline(3, "}")
    vim.fn.cursor(2, 0)
  end,
})
vim.api.nvim_create_autocmd("FileType", { pattern = "java", command = "setlocal autoindent shiftwidth=0 ts=2 sts=2" })
vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.java", callback = format("google-java-format", "-") })
