local km_utils = require("keymaps.utils")

km_utils.setKeymap("n", "<space>", "za") -- fold

km_utils.setKeymap("", "<Home>", "^") -- home
km_utils.setKeymap("i", "<Home>", "<Esc>^i", { noremap = false })

km_utils.setKeymap("t", "<A-Esc>", "<C-\\><C-n>") -- terminal
km_utils.setKeymap("", "<A-Esc>", "<Esc>")

km_utils.setKeymap("", "<C-Left>", ":vertical resize -1<CR>", {
  noremap = true, -- split window sizes
  silent = true,
})
km_utils.setKeymap("", "<C-Right>", ":vertical resize +1<CR>", {
  noremap = true,
  silent = true,
})
km_utils.setKeymap("", "<C-Up>", ":resize -1<CR>", {
  noremap = true,
  silent = true,
})
km_utils.setKeymap("", "<C-Down>", ":resize +1<CR>", {
  noremap = true,
  silent = true,
})

km_utils.setKeymap("n", "<C-h>", "<C-w>h") -- move between splits
km_utils.setKeymap("n", "<C-j>", "<C-w>j")
km_utils.setKeymap("n", "<C-k>", "<C-w>k")
km_utils.setKeymap("n", "<C-l>", "<C-w>l")

km_utils.setKeymap("", "<C-PageUp>", "<Esc>:tabprevious<CR>", false)
km_utils.setKeymap("", "<C-PageDown>", "<Esc>:tabnext<CR>", false)
km_utils.setKeymap("", "<C-S-PageUp>", "<Esc>:-tabmove<CR>", false)
km_utils.setKeymap("", "<C-S-PageDown>", "<Esc>:+tabmove<CR>", false)
-- km_utils.setKeymap("", "<C-w>", "<Esc>:tabclose<CR>", false)
km_utils.setKeymap("", "<C-t>", "<Esc>:tabnew<CR>")

-- km_utils.setKeymap("n", "q", ":q<CR>", { noremap = true })
