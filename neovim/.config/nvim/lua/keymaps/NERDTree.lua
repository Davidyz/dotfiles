require('keymaps.utils')

local function nerdtreeToggle()
  if vim.bo.filetype == 'nerdtree' then
    return ':NERDTreeClose<CR>'
  else
    return ':NERDTreeToggle<CR>'
  end
end

Set_keymap('n', '<Leader>t', nerdtreeToggle())
Set_keymap('v', '<Leader>t', nerdtreeToggle())
