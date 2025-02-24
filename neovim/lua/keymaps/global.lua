local km_utils = require("keymaps.utils")

km_utils.setKeymap("", "<Home>", function()
  local curr_line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local pref_str = curr_line:sub(0, cursor_pos[2])
  if pref_str:gsub("%s", "") == "" then
    return vim.api.nvim_win_set_cursor(0, { cursor_pos[1], 0 })
  else
    return vim.api.nvim_feedkeys("^", "n", false)
  end
end) -- home
km_utils.setKeymap("i", "<Home>", function()
  local curr_line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local pref_str = curr_line:sub(0, cursor_pos[2])
  if pref_str:gsub("%s", "") == "" then
    return vim.api.nvim_win_set_cursor(0, { cursor_pos[1], 0 })
  else
    for i = 0, cursor_pos[2] do
      if curr_line:sub(0, cursor_pos[2] - i):gsub("%s", "") == "" then
        return vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] - i })
      end
    end
  end
end, { noremap = false })

km_utils.setKeymap("t", "<A-Esc>", "<C-\\><C-n>") -- terminal
km_utils.setKeymap("", "<A-Esc>", "<Esc>")

km_utils.setKeymap("n", "<C-h>", "<C-w>h") -- move between splits
km_utils.setKeymap("n", "<C-j>", "<C-w>j")
km_utils.setKeymap("n", "<C-k>", "<C-w>k")
km_utils.setKeymap("n", "<C-l>", "<C-w>l")

km_utils.setKeymap("", "<C-PageUp>", "<Esc>:tabprevious<CR>", false)
km_utils.setKeymap("", "<C-PageDown>", "<Esc>:tabnext<CR>", false)
km_utils.setKeymap("", "<C-S-PageUp>", "<Esc>:-tabmove<CR>", false)
km_utils.setKeymap("", "<C-S-PageDown>", "<Esc>:+tabmove<CR>", false)
-- km_utils.setKeymap("", "<C-w>", "<Esc>:tabclose<CR>", false)
km_utils.setKeymap("", "<C-t>", function()
  vim.cmd("tabnew")
  require("snacks").dashboard.open({ win = 0, buf = 0 })
end)

-- km_utils.setKeymap("n", "q", ":q<CR>", { noremap = true })
