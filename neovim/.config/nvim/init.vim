if &shell =~# "\c*fish"
  set shell=sh
endif

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'neovimhaskell/haskell-vim', { 'for': ['haskell', 'hs'] }
Plug 'vim-pandoc/vim-pandoc', { 'for': ['markdown', 'pandoc', 'latex'] }
Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': ['markdown', 'pandoc', 'latex'] }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'vim-scripts/cup.vim'
Plug 'Yggdroot/indentLine'
Plug 'luochen1990/rainbow'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'goerz/jupytext.vim'
Plug 'udalov/javap-vim'
Plug 'tpope/vim-surround'
Plug 'psliwka/vim-smoothie'
Plug 'cespare/vim-toml', { 'branch': 'main' }
Plug 'mhinz/vim-startify'
Plug 'ervandew/supertab'
Plug 'mikelue/vim-maven-plugin'
Plug 'chaoren/vim-wordmotion'
Plug 'lark-parser/vim-lark-syntax', { 'for': ['lark'] }
Plug 'ryanoasis/vim-devicons'
Plug 'nvie/vim-flake8', { 'for': ['python'] }
Plug 'psf/black', { 'for': ['python'] }
Plug 'vim-scripts/crontab.vim'

Plug 'ayu-theme/ayu-vim'
Plug 'joshdick/onedark.vim'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }

if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'rafcamlet/coc-nvim-lua'
  Plug 'IngoMeyer441/coc_current_word'
  Plug 'github/copilot.vim'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'pandoc']}
endif

" All of your Plugins must be added before the following line
call plug#end()

if has('unix')
  let g:python3_host_prog = "/usr/bin/python3"
endif


let g:coc_global_extensions = ['coc-pyright', 'coc-java', 'coc-vimlsp', 'coc-sh', 'coc-tsserver', 'coc-clangd', 'coc-pairs', 'coc-snippets', 'coc-spell-checker', 'coc-rainbow-fart', 'coc-marketplace', 'coc-grammarly', 'coc-json', 'coc-ci', 'coc-docker', 'coc-lua']

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
filetype plugin on

lua require('misc')
" set encoding=UTF-8

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim80/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

" do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1
" set nu rnu
" set ts=4

if has("autocmd")                                                          
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" set guicursor=
let s:cursor_movement = v:true


highlight CurrentWord guibg=#cbccc6
" set foldmethod=indent
" set nofoldenable
" set foldlevelstart=99
" set mouse=a
" set noswapfile
" assumes set ignorecase smartcase

" nnoremap <space> za
filetype plugin on
" map <Home> ^
" imap <Home> <Esc>^i

" tnoremap <A-Esc> <C-\><C-n>
" noremap <A-Esc> <Esc>

lua require('keymaps.global')

" split related
" noremap <silent> <C-Left> :vertical resize -1<CR>
" noremap <silent> <C-Right> :vertical resize +1<CR>
" noremap <silent> <C-Up> :resize -1<CR>
" noremap <silent> <C-Down> :resize +1<CR>

" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" tabs related
" map <C-PageUp> <Esc>:tabprevious<CR>
" map <C-PageDown> <Esc>:tabnext<CR>
" imap <C-PageUp> <Esc>:tabprevious<CR>
" imap <C-PageDown> <Esc>:tabnext<CR>
" map <C-S-PageUp> <Esc>:-tabmove<CR>
" map <C-S-PageDown> <Esc>:+tabmove<CR>
" map <C-w> <Esc>:tabclose<CR>
" map <C-w> <Esc>:tabclose<CR>
" noremap <C-t> <Esc>:tabnew<CR>
" nnoremap <S-f> :tabnew<CR>:FZF<CR>
" nnoremap <S-r> :tabnew<CR>:Rg<CR>

" xmap <leader>a <Plug>(coc-codeaction-selected)
" nmap <leader>a <Plug>(coc-codeaction-selected)
" nmap <leader>r <Plug>(coc-rename)
" nmap <leader>f <Plug>(coc-fix-current)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

if &ft=="python"
  nmap <F5> :w<CR>:!clear;python %<CR>
endif

set laststatus=2
if !has('gui_running') && !has('termguicolors')
  set t_Co=256
endif

let g:source_code = ['java', 'c', 'cpp', 'python', 'hs', 'sh', 'go', 'php', 'json', 'bash', 'zsh', 'vim']
let g:texts = ['md', 'txt', 'markdown', 'rmd', 'pandoc', 'text']

let g:pandoc#modules#enabled = ["formatting", "bibliographies", "completion", "metadata", "menu", "keyboard", "toc", "spell"]
let g:pandoc#modules#disabled = ["folding", "hypertext", "conceal"]
let g:pandoc#syntax#conceal#use = 0

if index(g:source_code, &ft) >= 0
  let g:indentLine_setConceal = 0 
  let g:indentLine_enabled = 1
else
  let g:indentLine_setConceal = 1 
  let g:indentLine_enabled = 0
endif

let g:indentLine_setColor = 1
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '.'
let g:indentLine_char = '┆'

function! IsWord(...)
  return (a:0 =~ '[:alnum:]*([\.-/][:alnum:])*')
endfunction

function! WordCount()
  if index(g:texts ,&ft) == -1
    return ""
  else
    let s:old_status = v:statusmsg
    let position = getpos(".")
    exe ":silent normal g\<c-g>"
    let stat = v:statusmsg
    let s:word_count = 0
    if stat != '--No lines in buffer--'
      if stat =~ "^Selected"
        let s:word_count = str2nr(split(v:statusmsg)[5])
      else
        let s:word_count = str2nr(split(v:statusmsg)[11])
      end
      let v:statusmsg = s:old_status
    end
    call setpos('.', position)
    return s:word_count
  endif
endfunction

function! LightlineWebDevIcons()
  return WebDevIconsGetFileTypeSymbol(bufname())
endfunction

function! LightlineTabWebDevIcons(n)
  let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  return WebDevIconsGetFileTypeSymbol(bufname(l:bufnr))
endfunction

let g:lightline = { 
      \   'colorscheme': 'ayu',
      \ 'active': {
        \ 'left': [ ['readonly', 'mode', 'paste'], 
        \           ['gitbranch', 'icon', 'Hostname', 'absolutepath', 'modified'] ],
        \   'right': [ [ 'lineinfo' ], ['percent'], ['wordcount'] ],
        \ },
        \ 'component': {
          \   'readonly': '%{&filetype=="help"?"":&readonly?"\ue0a2":""}',
          \   'modified': '%{&filetype=="help"?"":&modified?"\ue0a0":&modifiable?"":"-"}',
          \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
          \   'gitbranch': gitbranch#name(),
          \ 'Hostname': '%{$USER}@%{hostname()}:'
          \ },
          \ 'component_function': {
            \   'wordcount': 'WordCount',
            \   'icon': 'LightlineWebDevIcons'
            \ },
            \ 'component_visible_condition': {
              \   'readonly': '(&filetype!="help"&& &readonly)',
              \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
              \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
              \   'gitbranch': 'gitbranch#name() != ""'
              \ },
              \   'separator': { 'left': '', 'right': '' },
              \   'subseparator': { 'left': '', 'right': '' },
              \ 'tab_component_function': {
                \ "tabnum": "LightlineTabWebDevIcons"
                \ }
                \ }

set noshowmode

filetype detect

augroup filetype
  au BufRead,BufNewFile *.flex,*.jflex,*.lex    set filetype=jflex
augroup END
autocmd FileType jflex setlocal expandtab autoindent ts=4 shiftwidth=0 softtabstop=-1

if index(["jflex", "flex", "lex"], &ft) != -1
  so ~/.config/nvim/syntax/jflex.vim
endif

augroup filetype
  au BufRead,BufNewFile *.cup set filetype=cup
augroup END
autocmd FileType cup setlocal expandtab autoindent ts=4 shiftwidth=0 softtabstop=-1 omnifunc=javacomplete#Complete 

autocmd FileType py setlocal ts=4 expandtab autoindent highlight ColorColumn ctermbg=magenta :call matchadd('ColorColumn', '\%81v', 100)
autocmd FileType lark setlocal ts=4 expandtab autoindent 
autocmd FileType markdown setlocal ts=2 expandtab autoindent
autocmd FileType pandoc setlocal ts=2 expandtab autoindent
autocmd FileType vim setlocal ts=2 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType c setlocal ts=4 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType javascript setlocal ts=4 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType json setlocal ts=4 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType cpp setlocal ts=4 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType arduino setlocal ts=4 expandtab autoindent shiftwidth=0 softtabstop=-1 path+=/home/$USER/Arduino/libraries/
autocmd FileType haskell setlocal ts=2 expandtab autoindent shiftwidth=0 softtabstop=-1
autocmd FileType html setlocal ts=2 expandtab autoindent sw=2
autocmd FileType yaml setlocal ts=2 expandtab autoindent sw=2
autocmd FileType xml setlocal ts=2 expandtab autoindent sw=2
autocmd FileType sh setlocal ts=4 expandtab autoindent
autocmd FileType zsh setlocal ts=4 expandtab autoindent
autocmd FileType fish setlocal ts=4 expandtab autoindent
autocmd FileType lua setlocal ts=2 expandtab autoindent

autocmd BufNewFile *.py
      \ exe "normal I\nif __name__ == '__main__':" .  "\npass\<Esc>1G"

set statusline+=%#warningmsg#
set statusline+=%*

syntax on

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 1
let g:cabal_indent_section = 2

let b:ale_linters = ['pyflakes', 'flake8', 'pylint']

let g:AutoPairs = {'(': ')', 
      \'[': ']', 
      \'{': '}',
      \"'": "'",
      \'"': '"', 
      \"`": "`", 
      \'```': '```', 
      \"'''": "'''", 
      \"${": "}$", 
      \"__": "__",
      \"$${": "}$$"}


autocmd FileType java setlocal expandtab autoindent ts=4 shiftwidth=0 softtabstop=-1 
autocmd FileType jsp setlocal expandtab autoindent ts=2 shiftwidth=0 softtabstop=-1 

autocmd BufNewFile *.java
      \ exe "normal Ipublic class " . expand('%:t:r') . "{\n}\<Esc>1G"

set clipboard+=unnamedplus

if index(g:texts, &ft) >= 0
  set tw=80
endif

if exists('g:started_by_firenvim') != 0
  let g:lightline = {}
  au BufEnter github.com_*.txt set filetype=markdown
  if (@% =~# "localhost_.*ipynb.*")
    set ft=python
  endif
endif

let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
nnoremap <Leader>c<space> NERDCommenterToggle<CR>
vnoremap <Leader>c<space> NERDCommenterToggle<CR>

let g:SuperTabDefaultCompletionType = "<c-n>"

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <c-space> coc#refresh()

let g:mkdp_preview_options = {
      \ 'mkit': {},
      \ 'katex': {},
      \ 'uml': {},
      \ 'maid': {},
      \ 'disable_sync_scroll': 0,
      \ 'sync_scroll_type': 'relative',
      \ 'hide_yaml_meta': 1,
      \ 'sequence_diagrams': {},
      \ 'flowchart_diagrams': {},
      \ 'content_editable': v:false,
      \ 'disable_filename': 0
      \ }

let g:mkdp_filetypes = ['markdown', 'pandoc', 'ipynb']
if index(g:mkdp_filetypes, &ft) >= 0
  nmap mp :MarkdownPreviewToggle<CR>
  let b:coc_pairs = [["${", "}$"], ["$${", "}$$"]]
endif

if &filetype == 'python'
  let b:coc_pairs = [["'''", "\n'''"]]
  nnoremap <F9> :Black<CR>
  let g:black_linelength = 80
endif

if &filetype == 'jsp'
  let b:coc_pairs = [["<%", "%>"]]
endif

let g:jupytext_fmt = 'py:light'

highlight clear CursorLine
set cursorline
highlight CursorLine ctermbg=DarkGray cterm=none
highlight Comment cterm=italic ctermfg=Red
highlight Pmenu ctermbg=DarkRed

let g:vim_json_conceal = 0

let b:copilot_enabled = 0

function! StartifyEntryFormat()
  return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
if has('nvim')
  au! TabNewEntered * Startify
endif

if has('termguicolors')
  set termguicolors
  set background=dark
endif

let g:ayucolor = 'mirage'
colorscheme ayu

hi MatchParen term=NONE cterm=NONE gui=NONE
hi VertSplit guifg=black
set fillchars+=vert:

nnoremap <Leader>t :NERDTreeToggle<CR>
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufEnter NERD_tree* :LeadingSpaceDisable
autocmd BufEnter NERD_tree* :let g:rainbow_active = 0
let NERDTreeNodeDelimiter="\x07"

let g:rainbow_active = 1


lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
