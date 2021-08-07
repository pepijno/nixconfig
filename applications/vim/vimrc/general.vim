if &shell =~# 'fish$'
	set shell=sh
endif

" Open current dir if no file specified
au VimEnter * if eval("@%") == "" | e . | endif

" General settings

let mapleader = " "                                                                      " Map leader to ' '
nnoremap <SPACE> <Nop>
set encoding=UTF-8                                                                       " Set encoding
set mouse=a                                                                              " Enable mouse
set syntax=on                                                                            " syntax highlighting
filetype plugin indent on                                                                " enable filetype detection
set modelines=0                                                                          " Disable modelines
set relativenumber                                                                       " Set line numbers
set nu                                                                                   " display current line number
set nohlsearch                                                                           " No hightlight when searched
set incsearch                                                                            " Set incremental search
set ignorecase                                                                           " ignore cases when searching
set smartcase                                                                            " Enable smart cases
set hidden                                                                               " Hidden buffers
set noerrorbells                                                                         " Remove error bell
set tabstop=4 softtabstop=4 shiftwidth=4                                                 " Tab settings
set noexpandtab                                                                          " don't expand tabs
set nowrap                                                                               " No wrapping
set noswapfile nobackup                                                                  " No backup and swap files
set undofile undodir=~/.vim/_undo/                                                       " Enable undo files
set signcolumn=yes colorcolumn=80                                                        " Always draw sign column
set cursorline                                                                           " Highlight current line
set cmdheight=2                                                                          " Set command prompt height
set list showbreak=↪\ listchars=eol:↵,tab:>-,nbsp:␣,trail:•,extends:>,precedes:<         " set visibiliyt of whitespaces
set matchpairs+=<:>                                                                      " Use % to jump between fish hooks
set lazyredraw foldenable foldlevelstart=10 foldnestmax=10 foldmethod=indent " Code folding
set scrolloff=999                                                                        " Set scrolloff super large, puts current line in the middle

" Load all *.vim files
for f in split(glob('$HOME/.config/nvim/nvim.d/*.vim'), '\n')
    exe 'source' f
endfor
