require('keymaps.utils')
require('utils')

function Show_documentation()
  if List_contains({'vim', 'help'}, vim.bo.filetype) then
    vim.api.nvim_command([[execute 'h '.expand('<cword>')]])
  elseif vim.fn['coc#rpc#ready'] then
    vim.api.nvim_command([[call CocActionAsync('doHover')]])
  else
    vim.api.nvim_command([[execute '!' . &keywordprg . " " . expand('<cword>')]])
  end
end

Set_keymap('n', 'K', ':call v:lua.Show_documentation()<CR>', { silent=true, noremap=true })
Set_keymap('x', '<leader>a', '<Plug>(coc-codeaction-selected)', false)
Set_keymap('n', '<leader>a', '<Plug>(coc-codeaction-selected)', false)
Set_keymap('n', '<leader>r', '<Plug>(coc-rename)', false)
Set_keymap('n', '<leader>f', '<Plug>(coc-fix-current)', false)
