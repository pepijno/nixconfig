if &shell =~# 'fish$'
	set shell=sh
endif

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
nnoremap <space> za
set foldmethod=indent
nnoremap gV `[v`]

" map kj to escape
inoremap kj <ESC>
cnoremap kj <ESC>
vnoremap kj <ESC>

" Map leader to ' '
let mapleader = " "
nnoremap <SPACE> <Nop>

" Toggle undo tree
nnoremap <leader>ut :UndotreeToggle<CR>

" fzf-vim keybindings
nmap <silent> <leader>ff :Files<CR>
nmap <silent> <leader>fc :Tags<CR>
nmap <silent> <leader>fr :Rg<CR>
nmap <silent> <leader>fl :Lines<CR>

" fzf window settings
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo' } }

let $FZF_DEFAULT_OPTS = '--info=inline'
let $FZF_DEFAULT_COMMAND="rg --files --hidden"
 
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" Move lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" (Un)quote word
nnoremap <Leader>q" ciw""<Esc>P
nnoremap <Leader>q' ciw''<Esc>P
nnoremap <Leader>qd daW"=substitute(@@,"'\\\|\"","","g")<CR>P

" vim-abolish
nnoremap <leader>rp :Subvert/

""""""""""""""""""""""""""""""""""""""" EASY MOTION
" map s to search for two chars
nmap s <Plug>(easymotion-overwin-f2)
nmap t <Plug>(easymotion-t2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
map <Leader>l <Plug>(easymotion-lineforward)

" Jumping to next/prev
nmap n <Plug>(easymotion-next)
nmap N <Plug>(easymotion-prev)

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

""""""""""""""""""""""""""""""""""""""" END EASY MOTION

" toggle tagbar
nmap <Leader>tt :TagbarToggle<CR>

" Color scheme
function! SetColorscheme()
	set termguicolors
	if strftime("%H") >= 8 && strftime("%H") < 20
		let g:ayucolor="light"
	else
		let g:ayucolor="mirage"
	endif
	colorscheme ayu
	hi Normal guibg=NONE ctermbg=NONE
endfunction

augroup backgr
	autocmd!
	autocmd CursorMoved,CursorHold,CursorHoldI,WinEnter,WinLeave,FocusLost,FocusGained,VimResized,ShellCmdPost * nested call SetColorscheme()
augroup END

" yank highlighting
let g:highlightedyank_highlight_duration = -1

" scrollbar
augroup ScrollbarInit
  autocmd!
  autocmd CursorMoved,VimResized,QuitPre * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
  autocmd WinLeave,FocusLost             * silent! lua require('scrollbar').clear()
augroup end

" EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" quick-scope
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary gui=underline cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary gui=underline cterm=underline
augroup END
