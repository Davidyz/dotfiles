local home_key_action = function()
  local curr_line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local pref_str = curr_line:sub(0, cursor_pos[2])
  if pref_str:gsub("%s", "") == "" and pref_str ~= "" then
    return vim.api.nvim_win_set_cursor(0, { cursor_pos[1], 0 })
  else
    local curr_line_length = curr_line:len()
    for i = 0, curr_line_length do
      if curr_line:sub(0, curr_line_length - i):gsub("%s", "") == "" then
        return vim.api.nvim_win_set_cursor(0, { cursor_pos[1], curr_line_length - i })
      end
    end
  end
end

vim.keymap.set("", "<Home>", home_key_action) -- home
vim.keymap.set("i", "<Home>", home_key_action, { noremap = false })

vim.keymap.set("t", "<A-Esc>", "<C-\\><C-n>") -- terminal
vim.keymap.set("", "<A-Esc>", "<Esc>")

vim.keymap.set("n", "<C-h>", "<C-w>h") -- move between splits
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("", "<C-PageUp>", "<Esc>:tabprevious<CR>", { noremap = false })
vim.keymap.set("", "<C-PageDown>", "<Esc>:tabnext<CR>", { noremap = false })
vim.keymap.set("", "<C-S-PageUp>", "<Esc>:-tabmove<CR>", { noremap = false })
vim.keymap.set("", "<C-S-PageDown>", "<Esc>:+tabmove<CR>", { noremap = false })
-- vim.keymap.set("", "<C-w>", "<Esc>:tabclose<CR>", false)
vim.keymap.set("", "<C-t>", function()
  vim.cmd("tabnew")
  require("snacks").dashboard.open({ win = 0, buf = 0 })
end)

vim.keymap.set("n", "<Leader>F", function()
  vim.g.format_on_save = not vim.g.format_on_save
end, {
  desc = "Toggle format on save.",
  noremap = true,
})

vim.keymap.set("n", "<BS>", "za", { noremap = true, desc = "Toggle fold." })
-- vim.keymap.set("n", "q", ":q<CR>", { noremap = true })
