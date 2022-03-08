require("keymaps.utils")
require("utils")

function Show_documentation()
	if List_contains({ "vim", "help" }, vim.bo.filetype) then
		vim.api.nvim_command([[execute 'h '.expand('<cword>')]])
	elseif vim.fn["coc#rpc#ready"] then
		vim.api.nvim_command([[call CocActionAsync('doHover')]])
	else
		vim.api.nvim_command([[execute '!' . &keywordprg . " " . expand('<cword>')]])
	end
end

vim.api.nvim_command([[
function! Check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
]])

Set_keymap("n", "K", ":call v:lua.Show_documentation()<CR>", { silent = true, noremap = true })
Set_keymap("x", "<leader>a", "<Plug>(coc-codeaction-selected)", false)
Set_keymap("n", "<leader>a", "<Plug>(coc-codeaction-selected)", false)
Set_keymap("n", "<leader>r", "<Plug>(coc-rename)", false)
Set_keymap("n", "<leader>f", "<Plug>(coc-fix-current)", false)

Set_keymap(
	"i",
	"<cr>",
	[[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
	{ silent = true, expr = true, noremap = true }
)
Set_keymap("i", "<c-space>", "coc#refresh()", { silent = true, expr = true, noremap = true })

Set_keymap(
	"i",
	"<TAB>",
	[[pumvisible() ? "\<C-n>" : Check_back_space() ? "\<TAB>" : coc#refresh()]],
	{ silent = true, expr = true, noremap = true }
)
Set_keymap("i", "<S-TAB>", [[pumvisible() ? "\<C-p>" : "\<C-h>"]], { silent = true, expr = true })
