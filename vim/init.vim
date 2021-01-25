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
set listchars=tab:→\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨

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

" Map leader to ','
let mapleader = ","

" Toggle undo tree
nnoremap <leader>ut :UndotreeToggle<CR>

" fzf-vim keybindings
nmap <silent> <leader>ff :Files<CR>
nmap <silent> <leader>fc :Tags<CR>
nmap <silent> <leader>fr :Rg<CR>
nmap <silent> <leader>fl :Lines<CR>

" fzf window settings
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

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

" colorscheme wal
" let g:lightline = {'colorscheme': 'gruvbox'}

""" make sure to create ctags on saving
"" au BufWritePost *.php execute '! sh -c "if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1 ; then ~/.git_template/hooks/ctags; fi"'

"" autocmd Filetype php setlocale ts=4 sts=4 sw=4

"" For plugins to load correctly
"filetype plugin indent on

"" Whitespace
"set textwidth=0
"set wrapmargin=0
"set formatoptions=tcqrn1

"" Cursor motion
"set backspace=indent,eol,start
"runtime! macros/matchit.vim

"" remaps for using tabs in vim
"nnoremap tn :tabnew<Space>
"nnoremap tj :tabfirst<CR>
"nnoremap tk :tablast<CR>
"nnoremap th :tabprev<CR>
"nnoremap tl :tabnext<CR>

"" sourcing and opening vimrc
"nnoremap <leader>ev :vsp $MYVIMRC<CR>
"nnoremap <leader>sv :source $MYVIMRC<CR>

"" enable ncm2 for all buffers
""autocmd BufEnter * call ncm2#enable_for_buffer()

"" IMPORTANT: :help Ncm2PopupOpen for more information
""set completeopt=noinsert,menuone,noselect

"" PHP cs Fixer
"let g:php_cs_fixer_path = "~/.config/composer/vendor/bin/php-cs-fixer"
"let g:php_cs_fixer_config = "default"

"let g:UltiSnipsExpandTrigger="<c-j>"
"let g:UltiSnipsJumpForwardTrigger="<c-j>"
"let g:UltiSnipsJumpBackwardTrigger="<c-b>"

"" PHP7
"let g:ultisnips_php_scalar_types = 1

"" augroup ncm2
""   au!
""   autocmd BufEnter * call ncm2#enable_for_buffer()
""   au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
""   au User Ncm2PopupClose set completeopt=menuone
"" augroup END

"" parameter expansion for selected entry via Enter
"" inoremap <silent> <expr> <CR> (pumvisible() ? ncm2_ultisnips#expand_or("\<CR>", 'n') : "\<CR>")

"" cycle through completion entries with tab/shift+tab
"inoremap <expr> <TAB> pumvisible() ? "\<c-n>" : "\<TAB>"
"inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<TAB>"

"" disable linting while typing
"let g:ale_lint_on_text_changed = 'never'
"let g:ale_lint_on_enter = 0
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"let g:ale_open_list = 1
"let g:ale_keep_list_window_open=0
"let g:ale_set_quickfix=0
"let g:ale_list_window_size = 5
"let g:ale_php_phpcbf_standard='PSR2'
"let g:ale_php_phpcs_standard='phpcs.xml.dist'
"let g:ale_php_phpmd_ruleset='phpmd.xml'
"let g:ale_fixers = {
"			\ '*': ['remove_trailing_lines', 'trim_whitespace'],
"			\ 'php': ['phpcbf', 'php_cs_fixer', 'remove_trailing_lines', 'trim_whitespace'],
"			\}
"let g:ale_fix_on_save = 1
"let g:ale_linters = {'c': ['gcc'], 'cpp': ['g++']}
"let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++17'

"let g:ale_cpp_gcc_executable = '/usr/bin/gcc'

"function! PHPModify(transformer)
"	:update
"	let l:cmd = "silent !".g:phpactor_executable." class:transform ".expand('%').' --transform='.a:transformer
"	execute l:cmd
"endfunction

"nnoremap <leader>ric :call PHPModify("implement_contracts")<cr>
"nnoremap <leader>raa :call PHPModify("add_missing_properties")<cr>
"nnoremap <leader>rmc :call PHPMoveClass()<cr>
"function! PHPMoveClass()
"	:w
"	let l:oldPath = expand('%')
"	let l:newPath = input("New path: ", l:oldPath)
"	execute "!".g:phpactor_executable." class:move ".l:oldPath.' '.l:newPath
"	execute "bd ".l:oldPath
"	execute "e ". l:newPath
"endfunction
"nnoremap <leader>rmd :call PHPMoveDir()<cr>
"function! PHPMoveDir()
"	:w
"	let l:oldPath = input("old path: ", expand('%:p:h'))
"	let l:newPath = input("New path: ", l:oldPath)
"	execute "!".g:phpactor_executable." class:move ".l:oldPath.' '.l:newPath
"endfunction

"nnoremap <Leader>u :PHPImportClass<cr>
"nnoremap <Leader>e :PHPExpandFQCNAbsolute<cr>
"nnoremap <Leader>E :PHPExpandFQCN<cr>

"let g:vim_php_refactoring_use_default_mapping = 0
"nnoremap <leader>rlv :call PhpRenameLocalVariable()<CR>
"nnoremap <leader>rcv :call PhpRenameClassVariable()<CR>
"nnoremap <leader>rrm :call PhpRenameMethod()<CR>
"nnoremap <leader>reu :call PhpExtractUse()<CR>
"vnoremap <leader>rec :call PhpExtractConst()<CR>
"nnoremap <leader>rep :call PhpExtractClassProperty()<CR>
"nnoremap <leader>rnp :call PhpCreateProperty()<CR>
"nnoremap <leader>rdu :call PhpDetectUnusedUseStatements()<CR>
"nnoremap <leader>rsg :call PhpCreateSettersAndGetters()<CR>

"function! IPhpInsertUse()
"	call PhpInsertUse()
"	call feedkeys('a',  'n')
"endfunction
"autocmd FileType php inoremap <Leader>pnu <Esc>:call IPhpInsertUse()<CR>
"autocmd FileType php noremap <Leader>pnu :call PhpInsertUse()<CR>
"function! IPhpExpandClass()
"	call PhpExpandClass()
"	call feedkeys('a', 'n')
"endfunction
"autocmd FileType php inoremap <Leader>pne <Esc>:call IPhpExpandClass()<CR>
"autocmd FileType php noremap <Leader>pne :call PhpExpandClass()<CR>
"let g:php_namespace_sort_after_insert=1
"let g:phpstan_analyse_level = 4

"set cursorline!

"autocmd BufRead,BufNewFile   *.hs set expandtab
"autocmd BufRead,BufNewFile   *.hs set tabstop=2
"autocmd BufRead,BufNewFile   *.hs set shiftwidth=2
"autocmd BufRead,BufNewFile   *.hs set softtabstop=2

"" vim gitgutter
"set updatetime=100

"let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
"let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
"let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
"let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
"let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
"let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
"let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
"let g:haskell_indent_case = 2
"let g:haskell_indent_case_alternative = 1

"nnoremap tf :call RunOrmolu()<CR>
