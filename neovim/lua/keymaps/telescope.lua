local builtin = require("telescope.builtin")

vim.keymap.set("n", "F", builtin.find_files, {})
if vim.fn.executable("rg") ~= 0 then
  vim.keymap.set("n", "R", builtin.live_grep, {})
end
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "TelescopePrompt",
  callback = function()
    vim.keymap.set({ "i", "n" }, "<esc>", function()
      vim.api.nvim_win_close(0, true)
    end, { replace_keycodes = true, buffer = 0, expr = true })
  end,
})

require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
})
require("telescope").load_extension("fzf")
