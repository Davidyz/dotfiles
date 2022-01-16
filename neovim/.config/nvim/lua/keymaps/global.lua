require('keymaps.utils')
require('utils')


Set_keymap('n', '<space>', 'za')  -- fold

Set_keymap('', '<Home>', '^')  -- home
Set_keymap('i', '<Home>', '<Esc>^i', {noremap = false})

Set_keymap('t', '<A-Esc>', '<C-\\><C-n>')  -- terminal
Set_keymap('', '<A-Esc>', '<Esc>')

Set_keymap('', '<C-Left>', ':vertical resize -1<CR>', { noremap = true,  -- split window sizes
                                                        silent = true })
Set_keymap('', '<C-Right>', ':vertical resize +1<CR>', { noremap = true,
                                                         silent = true })
Set_keymap('', '<C-Up>', ':resize -1<CR>', { noremap = true,
                                             silent = true })
Set_keymap('', '<C-Down>', ':resize +1<CR>', { noremap = true,
                                               silent = true })

Set_keymap('n', '<C-h>', '<C-w>h')  -- move between splits
Set_keymap('n', '<C-j>', '<C-w>j')
Set_keymap('n', '<C-k>', '<C-w>k')
Set_keymap('n', '<C-l>', '<C-w>l')

Set_keymap('', '<C-PageUp>', '<Esc>:tabprevious<CR>', false)
Set_keymap('', '<C-PageDown>', '<Esc>:tabnext<CR>', false)
Set_keymap('', '<C-S-PageUp>', '<Esc>:-tabmove<CR>', false)
Set_keymap('', '<C-S-PageDown>', '<Esc>:+tabmove<CR>', false)
Set_keymap('', '<C-w>', '<Esc>:tabclose<CR>', false)
Set_keymap('', '<C-t>', '<Esc>:tabnew<CR>')
Set_keymap('n', '<S-f>', ':tabnew<CR>:FZF<CR>')
Set_keymap('n', '<S-r>', ':tabnew<CR>:Rg<CR>')

