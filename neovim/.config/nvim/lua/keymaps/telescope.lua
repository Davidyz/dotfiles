local builtin = require("telescope.builtin")

vim.keymap.set("n", "F", builtin.find_files, {})
if vim.fn.executable("rg") ~= 0 then
  vim.keymap.set("n", "R", builtin.live_grep, {})
end
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
