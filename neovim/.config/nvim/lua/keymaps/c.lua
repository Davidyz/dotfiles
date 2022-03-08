vim.api.nvim_command(
	"autocmd FileType c map <buffer> <F5> :w<CR>:exec '!gcc % -o /tmp/temp.out && /tmp/temp.out && rm /tmp/temp.out'<CR>"
)
