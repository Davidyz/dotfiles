lua require('plugins.main')
lua require('misc')
lua require('keymaps.main')

" autocmd FileType py setlocal ts=4 expandtab autoindent :highlight ColorColumn ctermbg=magenta :call matchadd('ColorColumn', '\%81v', 100)
" autocmd FileType markdown setlocal ts=2 expandtab autoindent
" autocmd FileType pandoc setlocal ts=2 expandtab autoindent
autocmd FileType vim setlocal ts=2 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType c setlocal ts=4 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType javascript setlocal ts=2 expandtab autoindent shiftwidth=0 softtabstop=-1
" autocmd FileType json setlocal ts=4 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType cpp setlocal ts=4 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType arduino setlocal ts=4 expandtab autoindent shiftwidth=0 softtabstop=-1 path+=/home/$USER/Arduino/libraries/
autocmd FileType haskell setlocal ts=2 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType html setlocal ts=2 expandtab autoindent sw=2
autocmd FileType yaml setlocal ts=2 expandtab autoindent sw=2
autocmd FileType xml setlocal ts=2 expandtab autoindent sw=2
autocmd FileType sh setlocal ts=4 expandtab autoindent
autocmd FileType zsh setlocal ts=4 expandtab autoindent
autocmd FileType fish setlocal ts=4 expandtab autoindent
" autocmd FileType lua setlocal ts=2 expandtab autoindent


" autocmd FileType java setlocal expandtab autoindent ts=4 shiftwidth=0 softtabstop=-1
autocmd FileType jsp setlocal expandtab autoindent ts=2 shiftwidth=0 softtabstop=-1 
let g:SuperTabDefaultCompletionType = "<c-n>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <c-space> coc#refresh()
let g:mkdp_filetypes = ['markdown', 'pandoc', 'ipynb']
if &filetype == 'python'
  let b:coc_pairs = [["'''", "\n'''"]]
  nnoremap <F9> :Black<CR>
  let g:black_linelength = 80
endif
let g:jupytext_fmt = 'py:light'
highlight Comment cterm=italic ctermfg=Red
highlight Pmenu ctermbg=DarkRed
let b:copilot_enabled = 0

hi MatchParen term=NONE cterm=NONE gui=NONE
hi VertSplit guifg=black
set fillchars+=vert:
" autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" autocmd BufEnter NERD_tree* :LeadingSpaceDisable
" autocmd BufEnter NERD_tree* :let g:rainbow_active = 0
let g:rainbow_active = 1
lua require('filetype.main')
lua require('colorscheme.main')
