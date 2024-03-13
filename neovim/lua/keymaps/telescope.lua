local builtin = require("telescope.builtin")

vim.keymap.set("n", "F", builtin.find_files, {})
if vim.fn.executable("rg") ~= 0 then
  vim.keymap.set("n", "R", builtin.live_grep, {})
end
vim.keymap.set("n", "<Leader>b", builtin.buffers, {})
vim.keymap.set("n", "<Leader>f", builtin.quickfix, {})
vim.keymap.set("n", "<Leader>d", function()
  builtin.diagnostics({ bufnr = 0 })
end, {})
vim.keymap.set("n", "<leader>h", builtin.help_tags, {})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "TelescopePrompt",
  callback = function()
    vim.keymap.set({ "i", "n" }, "<esc>", function()
      vim.api.nvim_win_close(0, true)
    end, { replace_keycodes = true, buffer = 0, expr = true })
  end,
})
