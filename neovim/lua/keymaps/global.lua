local km_utils = require("keymaps.utils")

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

km_utils.setKeymap("", "<Home>", home_key_action) -- home
km_utils.setKeymap("i", "<Home>", home_key_action, { noremap = false })

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

km_utils.setKeymap("n", "<Leader>F", function()
  vim.g.format_on_save = not vim.g.format_on_save
end, {
  desc = "Toggle format on save.",
  noremap = true,
})

-- km_utils.setKeymap("n", "q", ":q<CR>", { noremap = true })
