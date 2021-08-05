if &shell =~# 'fish$'
	set shell=sh
endif
"
" Map leader to ' '
let mapleader = " "
nnoremap <SPACE> <Nop>

" Set encoding
set encoding=UTF-8

" Enable mouse
set mouse=a

" syntax highlighting
set syntax=on

" Disable modelines
set modelines=0

" Set line numbers
set relativenumber
set nu

" No hightlight when searched
set nohlsearch

" Set incremental search
set incsearch

" Case searching
set ignorecase
set smartcase

" Hidden buffers
set hidden

" Remove error bell
set noerrorbells

" Tab settings
set tabstop=4 softtabstop=4
set shiftwidth=4
set noexpandtab

" Wrapping
set wrap

" Backups, swap and undo
set noswapfile
set nobackup
set undodir=~/.vim/_undo/
set undofile

" scroll off 8
set scrolloff=8

" completions
set completeopt=menuone,noinsert,noselect,preview

" draw sign column
set signcolumn=yes
set colorcolumn=80

" line under cursor
set cursorline

" Command prompt height
set cmdheight=2

" Set whitespace chars visibility
set list
set showbreak=↪\
set listchars=eol:↵,tab:>-,nbsp:␣,trail:•,extends:>,precedes:<

" Use % to jump between fish hooks
set matchpairs+=<:>

" code folding
set lazyredraw
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
nnoremap gV `[v`]

" select all
nnoremap sa ggVG

" map kj to escape
inoremap kj <ESC>
cnoremap kj <ESC>
vnoremap kj <ESC>

" Move lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" (Un)quote word
nnoremap <leader>q" ciw""<Esc>P
nnoremap <leader>q' ciw''<Esc>P
nnoremap <leader>qd daW"=substitute(@@,"'\\\|\"","","g")<CR>P

" Create new file
nnoremap <leader>cf :e %:h/

" vim-abolish
nnoremap <leader>rp :Subvert/

" toggle tagbar
nmap <leader>tt :TagbarToggle<CR>

" scrollbar
" augroup ScrollbarInit
"   autocmd!
"   autocmd CursorMoved,VimResized,QuitPre * silent! lua require('scrollbar').show()
"   autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
"   autocmd WinLeave,FocusLost             * silent! lua require('scrollbar').clear()
" augroup end

" EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" quick-scope
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary gui=underline cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary gui=underline cterm=underline
augroup END

autocmd Filetype haskell setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" COC
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" inoremap <silent><expr> <tab> coc#refresh()

nmap <leader>rn <Plug>(coc-rename)
nmap <leader>fx <Plug>(coc-fix-current)
