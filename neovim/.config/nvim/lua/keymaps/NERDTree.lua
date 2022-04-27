local km_utils = require("keymaps.utils")

local function nerdtreeToggle()
  if vim.bo.filetype == "nerdtree" then
    return ":NERDTreeClose<CR>"
  else
    return ":NERDTreeToggle<CR>"
  end
end

km_utils.setKeymap("n", "<Leader>t", ":NERDTreeMirror<CR>:" .. nerdtreeToggle())
km_utils.setKeymap("v", "<Leader>t", ":NERDTreeMirror<CR>:" .. nerdtreeToggle())
